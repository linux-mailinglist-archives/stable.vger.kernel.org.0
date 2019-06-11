Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 685D23D71C
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 21:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405764AbfFKTnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 15:43:41 -0400
Received: from mout.gmx.net ([212.227.15.18]:34509 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405684AbfFKTnl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 15:43:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1560282198;
        bh=rJPROSVdwR6ZnC7bA4RU4rdMj1HTOUmtQvboZHKa2I4=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:References:Date:In-Reply-To;
        b=ENeZ6tBCaLcXlIsOkz/CILO1gjX3KcUGLzzj/dDr5QOclumnZb4f/Sqn3YjXJVhIq
         vEG1D1Q6kIz8urabR74PvzjpaLzYm6ISShr3bRNICd5XUCZXrhX+ouAA1pphiv0x1l
         27HtTd23ADj8rwIUOXDAgiBVQuyed0KouC6uQnSw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([79.203.76.133]) by mail.gmx.com
 (mrgmx003 [212.227.17.190]) with ESMTPSA (Nemesis) id
 0M3AWN-1iTi8v19F9-00szby; Tue, 11 Jun 2019 21:43:18 +0200
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 6E402800A7; Tue, 11 Jun 2019 21:43:16 +0200 (CEST)
From:   Sven Joachim <svenjoac@gmx.de>
To:     Thomas Backlund <tmb@mageia.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>
Subject: Re: Linux 5.1.9 build failure with CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT=n
References: <87k1dsjkdo.fsf@turtle.gmx.de> <20190611153656.GA5084@kroah.com>
        <CAKMK7uH_3P3pYkJ9Ua4hOFno5UiQ4p-rdWu9tPO75MxGCbyXSA@mail.gmail.com>
        <20190611174006.GB31662@kroah.com>
        <11b2d815-d0c0-1f68-557d-144166c4a1a7@mageia.org>
Date:   Tue, 11 Jun 2019 21:43:16 +0200
In-Reply-To: <11b2d815-d0c0-1f68-557d-144166c4a1a7@mageia.org> (Thomas
        Backlund's message of "Tue, 11 Jun 2019 22:08:10 +0300")
Message-ID: <877e9rkiwb.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K1:pdn6o2WKrDFA93eOZRPB+/Sd3nN6DzJyZ1hHqghwbcfPpgE7rIk
 kxuaqGSdTXa3M9nd23mQUXGphr1OBK4HwcucODxh/LyFyS/eZuWHrMljm0FolKFTgIjPtkX
 rDIEAlPg3zLS8ZPUsUYGhUIqFbk/baTmtS3jQoHNlZhiNFXOK6O163TFe5SUG/1UvfP3cE9
 YocgnUioN7xs8MLvB8L/g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:nzItbOkWVGY=:ucCMfTaVwZYckGKIrQMnAT
 NR+Z4RRiVw5/abjwMa+mf1pgzvTJlskS3E+IgNFJmKGQmP3lgVM6pgSyqfRLYKI/eJ6vtKx6x
 g3nKzvFTmQXVhzLqxRr3LV161vMBhIPKpGynkzfQM/b0NOAp9p/MQIkGmE1CRm6AowABbpaLh
 fWo6CJ4wGpEKQSTPhLfgF8VxS3kz4Q9Ri7QCsVG0w4lRovvQ9yXcFGhgmCGQLc/Hk85uApWTx
 X16djK/wqc8xySx+/hNdgR/+zvUlzyBv3rqJfhGBIzWTOaHJvrMM1hV2QeZ+dCVPu9ACIiYRY
 LEYs01oNr6X7XMhFWs5SolIeIlUZljS+ChseGJZ+4kW1aWleeCOBpiV2I02MRfY2GZ89oMTKt
 bRFDRbTQp2zxxtikedRctkHCsXJDU5bMtpb7HAGEj/7xvkZzhpOCvf9Bk3dchD9laCMxksvw7
 vrIBdUHMOC/tlKPthGBJqNaOPqgq1EXyTq9hav6kxQ+CX3PDAx3E9UscupnP87hsXnpvRDeND
 HH/MN4hftzz90RywK8fhsQNyxf8NZjYb/Sc5zwhFIGj1pTZPVlK/iNtG5Wmwye1YXqGs9rQIi
 IEKqi7OU3tuL2gKwIo9eYjjh6g904XU5LNAMUDSu4qSksQjH+AuvooGk9qhFJUz6Qc+e9Rzfd
 GGQEQsZ2JaKceP0K2fa4Zv56PanLaecY1CE4SJ5YHWR5XkocXO3QfQB3q6he5RDuPGfhHmwTC
 VPCRrPisXZ11XNwLcKXaQRNpExsXgKxe+L/TVqJ8ZVluev/PYXGhJL/IsceY6u0+hUzN5pgF7
 D6dSZR9/QBleIrVcPXiWXjc308m52aVQL7DjhPpzC0XWLY5/WrMEM1uJqhekjLKeTP4UYkMVf
 AnejSbC5+BrqVlEKxBKoVIAFrY0yfLswPmN2SQT76GeFbguY3Shwh5WwKBOwPw/f10SWitzF1
 xkPJzwl658CKZYuBKoNcZcmT4w48JQOBZjxhIdbMdh7uCCaqZBfro
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019-06-11 22:08 +0300, Thomas Backlund wrote:

> Den 11-06-2019 kl. 20:40, skrev Greg Kroah-Hartman:
>> On Tue, Jun 11, 2019 at 07:33:16PM +0200, Daniel Vetter wrote:
>>> On Tue, Jun 11, 2019 at 5:37 PM Greg Kroah-Hartman
>>> <gregkh@linuxfoundation.org> wrote:
>>>> On Tue, Jun 11, 2019 at 03:56:35PM +0200, Sven Joachim wrote:
>>>>> Commit 1e07d63749 ("drm/nouveau: add kconfig option to turn off nouv=
eau
>>>>> legacy contexts. (v3)") has caused a build failure for me when I
>>>>> actually tried that option (CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT=3Dn):
>>>>>
>>>>> ,----
>>>>> | Kernel: arch/x86/boot/bzImage is ready  (#1)
>>>>> |   Building modules, stage 2.
>>>>> |   MODPOST 290 modules
>>>>> | ERROR: "drm_legacy_mmap" [drivers/gpu/drm/nouveau/nouveau.ko] unde=
fined!
>>>>> | scripts/Makefile.modpost:91: recipe for target '__modpost' failed
>>>>> `----
>>>
>>> Calling drm_legacy_mmap is definitely not a great idea. I think either
>>> we need a custom patch to remove that out on older kernels, or maybe
>>> even #ifdef if you want to be super paranoid about breaking stuff ...
>>>
>>>>> Upstream does not have that problem, as commit bed2dd8421 ("drm/ttm:
>>>>> Quick-test mmap offset in ttm_bo_mmap()") has removed the use of
>>>>> drm_legacy_mmap from nouveau_ttm.c.  Unfortunately that commit does =
not
>>>>> apply in 5.1.9.
>>>>>
>>>>> Most likely 4.19.50 and 4.14.125 are also affected, I haven't tested
>>>>> them yet.
>>>>
>>>> They probably are.
>>>>
>>>> Should I just revert this patch in the stable tree, or add some other
>>>> patch (like the one pointed out here, which seems an odd patch for
>>>> stable...)
>>>
>>> ... or backport the above patch, that should be save to do too. Not
>>> sure what stable folks prefer?
>>
>> The above patch does not apply to all of the stable branches, so how
>> about I just revert this?  People can live with this option not able to
>> turn off for now, and if they really want it, they can use a newer
>> kernel, right?
>>
>
> Or add the simple fix suggested by Daniel (if I understand correctly):
>
>
> From: Thomas Backlund <tmb@mageia.org>
>
> Setting CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT=3Dn (added by commit:
> b30a43ac7132) causes the build to fail with:
>
> ERROR: "drm_legacy_mmap" [drivers/gpu/drm/nouveau/nouveau.ko] undefined!
>
> Fix that by adding check for CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT around
> the code using drm_legacy_mmap()
>
> Fixes: b30a43ac7132 drm/nouveau: add kconfig option to turn off
> nouveau legacy contexts. (v3)
> Signed-off-by: Thomas Backlund <tmb@mageia.org>
>
> ---
>  drivers/gpu/drm/nouveau/nouveau_ttm.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> --- a/drivers/gpu/drm/nouveau/nouveau_ttm.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_ttm.c
> @@ -168,8 +168,10 @@ nouveau_ttm_mmap(struct file *filp, stru
>  	struct drm_file *file_priv =3D filp->private_data;
>  	struct nouveau_drm *drm =3D nouveau_drm(file_priv->minor->dev);
>
> +#if defined(CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT)
>  	if (unlikely(vma->vm_pgoff < DRM_FILE_PAGE_OFFSET))
>  		return drm_legacy_mmap(filp, vma);
> +#endif
>
>  	return ttm_bo_mmap(filp, vma, &drm->ttm.bdev);
>  }

That's not quite correct, I am afraid.  If
CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT is not defined, you still need to do
the test, but return -EINVAL.  Something along these lines:

diff --git a/drivers/gpu/drm/nouveau/nouveau_ttm.c b/drivers/gpu/drm/nouve=
au/nouveau_ttm.c
index 1543c2f8d3d3..05d513d54555 100644
=2D-- a/drivers/gpu/drm/nouveau/nouveau_ttm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_ttm.c
@@ -169,7 +169,11 @@ nouveau_ttm_mmap(struct file *filp, struct vm_area_st=
ruct *vma)
 	struct nouveau_drm *drm =3D nouveau_drm(file_priv->minor->dev);

 	if (unlikely(vma->vm_pgoff < DRM_FILE_PAGE_OFFSET))
+#if defined(CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT)
 		return drm_legacy_mmap(filp, vma);
+#else
+		return -EINVAL;
+#endif

 	return ttm_bo_mmap(filp, vma, &drm->ttm.bdev);
 }


At least that builds for me, need to reboot to check whether it works.

Cheers,
       Sven
