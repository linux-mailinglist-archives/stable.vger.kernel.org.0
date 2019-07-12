Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDD9D674B6
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 19:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbfGLRvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 13:51:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35024 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbfGLRvA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 13:51:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6CHiQUo182558;
        Fri, 12 Jul 2019 17:50:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=ttLP7k6LnQunc74kkiwUZeNR1lEb3Y0sGTeUpabWr0I=;
 b=PKj2zHQbTQcG3FiOlWudYS4C1QKpDC4EWtBtcI+eiGu8hNFd01ee4AV0dhdHrkQlFo+0
 I7HJh8gyiH8MyjA0K+zA9NySz17GMEcjDYX3D6Q0HSfxXFUxlqACLBpmTiIau0tdBUK6
 Bl9PNEUXrGQPoNDPmOvbceMvWnn8kn8jCoP4mG8UWm67b9dJNAU3NLE8opploNKXL+4r
 WegsU2vPTBCcGW2ee5eeJ4csDG9Y2MryuvrBWGz84L5D8KZ3eoSxxPk2+Uq62ZMHMlTa
 O1xZZxGk9qJK72kNfnMHgXUrj9iYzNnmty75QDfoMTOxFfmeF1kuPWdmcBhYnVEdMYGV eA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2tjkkq6xjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 17:50:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6CHlsHr123708;
        Fri, 12 Jul 2019 17:50:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2tpefd7h4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 17:50:54 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6CHorrW009828;
        Fri, 12 Jul 2019 17:50:53 GMT
Received: from localhost (/10.159.245.178)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Jul 2019 10:50:53 -0700
Date:   Fri, 12 Jul 2019 10:50:52 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Boaz Harrosh <boaz@plexistor.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/3] fs: Export generic_fadvise()
Message-ID: <20190712175052.GZ1404256@magnolia>
References: <20190711140012.1671-1-jack@suse.cz>
 <20190711140012.1671-3-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711140012.1671-3-jack@suse.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9316 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907120180
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9316 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907120180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 11, 2019 at 04:00:11PM +0200, Jan Kara wrote:
> Filesystems will need to call this function from their fadvise handlers.
> 
> CC: stable@vger.kernel.org # Needed by "xfs: Fix stale data exposure when
> 					readahead races with hole punch"
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  include/linux/fs.h | 2 ++
>  mm/fadvise.c       | 4 ++--
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index f7fdfe93e25d..2666862ff00d 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -3536,6 +3536,8 @@ extern void inode_nohighmem(struct inode *inode);
>  /* mm/fadvise.c */
>  extern int vfs_fadvise(struct file *file, loff_t offset, loff_t len,
>  		       int advice);
> +extern int generic_fadvise(struct file *file, loff_t offset, loff_t len,
> +			   int advice);
>  
>  #if defined(CONFIG_IO_URING)
>  extern struct sock *io_uring_get_socket(struct file *file);
> diff --git a/mm/fadvise.c b/mm/fadvise.c
> index 467bcd032037..4f17c83db575 100644
> --- a/mm/fadvise.c
> +++ b/mm/fadvise.c
> @@ -27,8 +27,7 @@
>   * deactivate the pages and clear PG_Referenced.
>   */
>  
> -static int generic_fadvise(struct file *file, loff_t offset, loff_t len,
> -			   int advice)
> +int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
>  {
>  	struct inode *inode;
>  	struct address_space *mapping;
> @@ -178,6 +177,7 @@ static int generic_fadvise(struct file *file, loff_t offset, loff_t len,
>  	}
>  	return 0;
>  }
> +EXPORT_SYMBOL(generic_fadvise);
>  
>  int vfs_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
>  {
> -- 
> 2.16.4
> 
