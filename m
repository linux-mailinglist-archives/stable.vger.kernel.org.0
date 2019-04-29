Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2B85DF65
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 11:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbfD2J0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 05:26:30 -0400
Received: from mail-eopbgr140078.outbound.protection.outlook.com ([40.107.14.78]:39905
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727325AbfD2J0a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Apr 2019 05:26:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G93oOUjliS8cvKmcSmdDz/W7Oiyr4bcw36C0TkiYXd8=;
 b=j4W0hD6dRRC+oyNtGMDXnlzOLZTRG3+t2cWvPr2lzLJEBXaWdZOYdweaz7Og6J5MHd2yIquCUQmSzBokqhXKxUKPE+gdawwxIi+zMPXS5tDEEAid1Uvz0qVxr8D932EcXOM3qCIPZNjKaU8ZulRDm2Co6AUr479WW41kZfMtCO8=
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com (10.171.186.14) by
 AM4PR05MB3426.eurprd05.prod.outlook.com (10.171.188.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Mon, 29 Apr 2019 09:26:24 +0000
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::edfd:88b8:1f9e:d5b1]) by AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::edfd:88b8:1f9e:d5b1%7]) with mapi id 15.20.1835.018; Mon, 29 Apr 2019
 09:26:24 +0000
From:   Leon Romanovsky <leonro@mellanox.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "aarcange@redhat.com" <aarcange@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>
Subject: Re: Patch "RDMA/ucontext: Fix regression with disassociate" has been
 added to the 5.0-stable tree
Thread-Topic: Patch "RDMA/ucontext: Fix regression with disassociate" has been
 added to the 5.0-stable tree
Thread-Index: AQHU/mutNqHW6rzKRUyj5tXmPMQ9VKZS3l+A
Date:   Mon, 29 Apr 2019 09:26:24 +0000
Message-ID: <20190429092621.GU6705@mtr-leonro.mtl.com>
References: <15565291094471@kroah.com>
In-Reply-To: <15565291094471@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR0202CA0023.eurprd02.prod.outlook.com
 (2603:10a6:208:1::36) To AM4PR05MB3137.eurprd05.prod.outlook.com
 (2603:10a6:205:3::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [77.138.135.184]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e6b47c4a-3c5b-4637-1f7b-08d6cc84bf60
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3426;
x-ms-traffictypediagnostic: AM4PR05MB3426:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <AM4PR05MB3426C49D5E6429F7D42E4014B0390@AM4PR05MB3426.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(136003)(366004)(396003)(39860400002)(346002)(189003)(199004)(53936002)(68736007)(6506007)(2501003)(102836004)(66066001)(478600001)(64756008)(66446008)(66946007)(305945005)(6246003)(486006)(54906003)(476003)(110136005)(66556008)(25786009)(11346002)(66476007)(73956011)(86362001)(229853002)(14454004)(386003)(186003)(97736004)(5660300002)(53546011)(26005)(2906002)(99286004)(6116002)(3846002)(81166006)(81156014)(8676002)(52116002)(33656002)(1076003)(8936002)(316002)(446003)(4326008)(6306002)(71200400001)(6436002)(6512007)(71190400001)(9686003)(7736002)(76176011)(966005)(6486002)(14444005)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3426;H:AM4PR05MB3137.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DHNJGWokbdQNjNtTUlWuYz0Nt/Sbv4JXgBWt9Zte+hfd44J3atSurKKCvdJ2CxkUUn14bngf3yMa3aOTBZ6IkL2vFB7bq1Bz6Jjlhdb2FqBszglKlaDxISj2MSYt85cXXPEb+nlQeDV+oPpXssCbCPyBXaNneqYIopeSjIDTZELorBUay7GPUhFz2E3BbnAJ+IRvE4CvgAUYZ6OwfiJ/MxgTPmvn68TEFXUn3ZX5Ijduaa0x0x7kYCaCHpGj9dJsIxVsKCdYUsnouSCnUuvOV3QZHBv1Yvqkodm0zGCgNSbFTH6uYEwYpZrXh94vcZZXNCyRG6dfD5EYl+mCnqvcZ3/x1IQr9jhUXGoHs3gE/2ZfC+yAhFr31kt+rAUWqZ6dphQuUQlGXGvhiU1wgU4IaTn108+L2czLtp0go/xv0bs=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3F5E40517E521F4AA05702935B3188E5@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6b47c4a-3c5b-4637-1f7b-08d6cc84bf60
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 09:26:24.2728
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3426
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 29, 2019 at 11:11:49AM +0200, gregkh@linuxfoundation.org wrote:
>
> This is a note to let you know that I've just added the patch titled
>
>     RDMA/ucontext: Fix regression with disassociate
>
> to the 5.0-stable tree which can be found at:
>     http://www.kernel.org/git/?p=3Dlinux/kernel/git/stable/stable-queue.g=
it;a=3Dsummary
>
> The filename of the patch is:
>      rdma-ucontext-fix-regression-with-disassociate.patch
> and it can be found in the queue-5.0 subdirectory.
>
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

Greg,

Please be aware that this patch has compilation issues on s390 platform.
https://patchwork.kernel.org/patch/10920895/#22610993

Thanks

>
>
> From 67f269b37f9b4d52c5e7f97acea26c0852e9b8a1 Mon Sep 17 00:00:00 2001
> From: Jason Gunthorpe <jgg@mellanox.com>
> Date: Tue, 16 Apr 2019 14:07:28 +0300
> Subject: RDMA/ucontext: Fix regression with disassociate
>
> From: Jason Gunthorpe <jgg@mellanox.com>
>
> commit 67f269b37f9b4d52c5e7f97acea26c0852e9b8a1 upstream.
>
> When this code was consolidated the intention was that the VMA would
> become backed by anonymous zero pages after the zap_vma_pte - however thi=
s
> very subtly relied on setting the vm_ops =3D NULL and clearing the VM_SHA=
RED
> bits to transform the VMA into an anonymous VMA. Since the vm_ops was
> removed this broke.
>
> Now userspace gets a SIGBUS if it touches the vma after disassociation.
>
> Instead of converting the VMA to anonymous provide a fault handler that
> puts a zero'd page into the VMA when user-space touches it after
> disassociation.
>
> Cc: stable@vger.kernel.org
> Suggested-by: Andrea Arcangeli <aarcange@redhat.com>
> Fixes: 5f9794dc94f5 ("RDMA/ucontext: Add a core API for mmaping driver IO=
 memory")
> Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>  drivers/infiniband/core/uverbs.h      |    1
>  drivers/infiniband/core/uverbs_main.c |   52 +++++++++++++++++++++++++++=
+++++--
>  2 files changed, 50 insertions(+), 3 deletions(-)
>
> --- a/drivers/infiniband/core/uverbs.h
> +++ b/drivers/infiniband/core/uverbs.h
> @@ -160,6 +160,7 @@ struct ib_uverbs_file {
>
>  	struct mutex umap_lock;
>  	struct list_head umaps;
> +	struct page *disassociate_page;
>
>  	struct idr		idr;
>  	/* spinlock protects write access to idr */
> --- a/drivers/infiniband/core/uverbs_main.c
> +++ b/drivers/infiniband/core/uverbs_main.c
> @@ -208,6 +208,9 @@ void ib_uverbs_release_file(struct kref
>  		kref_put(&file->async_file->ref,
>  			 ib_uverbs_release_async_event_file);
>  	put_device(&file->device->dev);
> +
> +	if (file->disassociate_page)
> +		__free_pages(file->disassociate_page, 0);
>  	kfree(file);
>  }
>
> @@ -876,9 +879,50 @@ static void rdma_umap_close(struct vm_ar
>  	kfree(priv);
>  }
>
> +/*
> + * Once the zap_vma_ptes has been called touches to the VMA will come he=
re and
> + * we return a dummy writable zero page for all the pfns.
> + */
> +static vm_fault_t rdma_umap_fault(struct vm_fault *vmf)
> +{
> +	struct ib_uverbs_file *ufile =3D vmf->vma->vm_file->private_data;
> +	struct rdma_umap_priv *priv =3D vmf->vma->vm_private_data;
> +	vm_fault_t ret =3D 0;
> +
> +	if (!priv)
> +		return VM_FAULT_SIGBUS;
> +
> +	/* Read only pages can just use the system zero page. */
> +	if (!(vmf->vma->vm_flags & (VM_WRITE | VM_MAYWRITE))) {
> +		vmf->page =3D ZERO_PAGE(vmf->vm_start);
> +		get_page(vmf->page);
> +		return 0;
> +	}
> +
> +	mutex_lock(&ufile->umap_lock);
> +	if (!ufile->disassociate_page)
> +		ufile->disassociate_page =3D
> +			alloc_pages(vmf->gfp_mask | __GFP_ZERO, 0);
> +
> +	if (ufile->disassociate_page) {
> +		/*
> +		 * This VMA is forced to always be shared so this doesn't have
> +		 * to worry about COW.
> +		 */
> +		vmf->page =3D ufile->disassociate_page;
> +		get_page(vmf->page);
> +	} else {
> +		ret =3D VM_FAULT_SIGBUS;
> +	}
> +	mutex_unlock(&ufile->umap_lock);
> +
> +	return ret;
> +}
> +
>  static const struct vm_operations_struct rdma_umap_ops =3D {
>  	.open =3D rdma_umap_open,
>  	.close =3D rdma_umap_close,
> +	.fault =3D rdma_umap_fault,
>  };
>
>  static struct rdma_umap_priv *rdma_user_mmap_pre(struct ib_ucontext *uco=
ntext,
> @@ -888,6 +932,9 @@ static struct rdma_umap_priv *rdma_user_
>  	struct ib_uverbs_file *ufile =3D ucontext->ufile;
>  	struct rdma_umap_priv *priv;
>
> +	if (!(vma->vm_flags & VM_SHARED))
> +		return ERR_PTR(-EINVAL);
> +
>  	if (vma->vm_end - vma->vm_start !=3D size)
>  		return ERR_PTR(-EINVAL);
>
> @@ -991,7 +1038,7 @@ void uverbs_user_mmap_disassociate(struc
>  		 * at a time to get the lock ordering right. Typically there
>  		 * will only be one mm, so no big deal.
>  		 */
> -		down_write(&mm->mmap_sem);
> +		down_read(&mm->mmap_sem);
>  		if (!mmget_still_valid(mm))
>  			goto skip_mm;
>  		mutex_lock(&ufile->umap_lock);
> @@ -1005,11 +1052,10 @@ void uverbs_user_mmap_disassociate(struc
>
>  			zap_vma_ptes(vma, vma->vm_start,
>  				     vma->vm_end - vma->vm_start);
> -			vma->vm_flags &=3D ~(VM_SHARED | VM_MAYSHARE);
>  		}
>  		mutex_unlock(&ufile->umap_lock);
>  	skip_mm:
> -		up_write(&mm->mmap_sem);
> +		up_read(&mm->mmap_sem);
>  		mmput(mm);
>  	}
>  }
>
>
> Patches currently in stable-queue which might be from jgg@mellanox.com ar=
e
>
> queue-5.0/rdma-ucontext-fix-regression-with-disassociate.patch
> queue-5.0/ib-rdmavt-fix-frwr-memory-registration.patch
> queue-5.0/rdma-mlx5-use-rdma_user_map_io-for-mapping-bar-pages.patch
> queue-5.0/rdma-mlx5-do-not-allow-the-user-to-write-to-the-clock-page.patc=
h
