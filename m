Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87981411125
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 10:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235534AbhITIpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 04:45:00 -0400
Received: from mout.gmx.net ([212.227.17.21]:33775 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230053AbhITIo7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 04:44:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1632127393;
        bh=Vk08GIeN2gujJfYeYcM6KTBuE5acYhQZAFEElPjDbGI=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=aWZczAo/3WERabiLMsJerqOLJHZM0uaB3hbg2wMr2Il35B2XjLCpM3gNq2qveXJUb
         /2CaipKMNnowEwhKg2Vkz0rdiKPKO2THKJnvMOuZE4uo9Czg/7wNawLz55qeXUSZtG
         QAtHMbANF+vLArjB1NM4j7BsnLY1tTrpEIUgZ3EI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.20.59] ([92.116.139.149]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MmlXK-1nC41f03Ak-00jraj; Mon, 20
 Sep 2021 10:43:13 +0200
Subject: Re: Patch "parisc: Declare pci_iounmap() parisc version only when
 CONFIG_PCI enabled" has been added to the 4.9-stable tree
To:     gregkh@linuxfoundation.org, James.Bottomley@hansenpartnership.com,
        arnd@arndb.de, krypton@ulrich-teichert.org, linux@roeck-us.net,
        torvalds@linux-foundation.org, stable <stable@vger.kernel.org>
Cc:     stable-commits@vger.kernel.org
References: <163212635420164@kroah.com>
From:   Helge Deller <deller@gmx.de>
Message-ID: <f64c47bf-9426-73d9-a0b5-e2b8b5e2bf80@gmx.de>
Date:   Mon, 20 Sep 2021 10:43:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <163212635420164@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:zuu4RDunAz/hhlTmWTN04mo3WLf6R7/g9pVwGKSBi/lSXdkWZB1
 ttRv0sZoa1t4IzXTmPlc2d1wNgEzBWIODL25m/GrcUO6l+RjVAv7X9jwYUI51TdkUoArFuP
 LNtn7mytr2fc2J35TCL2yCs761Au2q/FmaUPXcTXs6J+pCKVRviHA5Jm7CNV/jiiMVFhGtB
 S+6saYTBFpoYBQYKG77SQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:xBpNhdfgcaE=:7WbZf/EQ65Q9uC6iwOwgPL
 d+7kjAE3Lzj/aqb/j3SlcsDWBpRyNT/PatCS/SJkwsBBh/odSnJzn72Ow+YrP1tnBsHl/NVPI
 D9AcoJb+5sOhVaxwX6k9g/MERK5gyBVrOI3cvsj6+5PjYjKOjuFWhAzmwId8da/Xmq1Sru5mp
 Rqj5dzKxQg6SS++MfAG0JVdolRhyz9DsPExqZDDKeGqLUhx1AXbqps2ncPTRuGmpoLniBmsaW
 0L5bvj6NSWeA8G6aObeEk9j7bC+MvqpEwPwKRBzB6IDLG7m560agCwHfaAaPtQvnbW4N46NL2
 eqe3/3VIYnPEs/ONyYWp+IV492RFrX72UVBw7SpTjgOcsizSaAZyvtb+V9JlM8k70bGh1D04T
 dyEAY8dMtxps2Y5L/QdMpxGOMdju2HMNjZL/+IkPe6sREAWJftAGh1N2DM/Iu7kQqY/8UXfzA
 ZjIu1XmFHksLY0RWCCfBY6mDbc/DGTT5sTZtZAG4+gF0tW8P6n3tjaUFuOHjUF6ee12NzLHIM
 oUfdPySCUEVbNbwI4LTkJCBnM1Md0+WH6jL0WDuZE4va2CZ7wLsxqfiTbip83W+RzD5Qp61Ev
 BVIMk8JA/nR83tc0daR+JYj24lG6WNRk6rbMWFekpQ8o/e7pVdDQjfPahyveERX9uS6Tutg0u
 w6r22Ztpw7pzvPzgZljdZk1orfnXKeDZjVnq4rFRApptjgHhIKxC5yU/6vgmJwTPjigHDP3CY
 DGKHl84aIFsLqysLglBcNN6L2RSx8E7DQ2aOCrnszFV2s/vUIE7+Kb9OeUHCtmk/L9WZ83eU7
 r7pW8VcD8fKoh3Mh1dinJy4ex3jQFwu//VRQeNJLXN5riCrycVxQEzbj/bdh4vDHy2KnuN32X
 a8B84ZYHVpMv2aI3ZC20Fk2m+13b3z+7G+/iwV6bjPs4nLiCvKS3k5RMHzgVV08V376GcTjNQ
 Vi829QlsKkqV8o4QfElCnNpzYPVVO3TDjIsHj2WnFdZYsBfPlFlP0+rj70T99QdogDqna49Mb
 6CPEql+gGk/0VWHlntrty5w+YHVqU2WHr+3WK5KE1alg7g4E/hwcgx0WOwKfAOyBGzo00NY0v
 uFfWzZjdUe8x3U=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/20/21 10:25 AM, gregkh@linuxfoundation.org wrote:
>
> This is a note to let you know that I've just added the patch titled
>
>      parisc: Declare pci_iounmap() parisc version only when CONFIG_PCI e=
nabled
>
> to the 4.9-stable tree which can be found at:
>      http://www.kernel.org/git/?p=3Dlinux/kernel/git/stable/stable-queue=
.git;a=3Dsummary
>
> The filename of the patch is:
>       parisc-declare-pci_iounmap-parisc-version-only-when-config_pci-ena=
bled.patch
> and it can be found in the queue-4.9 subdirectory.
>
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.


No, please don't add it to any stable tree yet.
This patch was applied by Linus in order to fix build errors on the alpha
architecture, but it triggers build errors on arm64 (and maybe other arche=
s).
The whole issue is still being analyzed, as visible in e.g. this commit:

316e8d79a0959c302b0c462ab64b069599f10eef
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Sep 19 17:13:35 2021 -0700
     pci_iounmap'2: Electric Boogaloo: try to make sense of it all


Helge





>
>
>  From 9caea0007601d3bc6debec04f8b4cd6f4c2394be Mon Sep 17 00:00:00 2001
> From: Helge Deller <deller@gmx.de>
> Date: Sun, 19 Sep 2021 10:36:09 -0700
> Subject: parisc: Declare pci_iounmap() parisc version only when CONFIG_P=
CI enabled
>
> From: Helge Deller <deller@gmx.de>
>
> commit 9caea0007601d3bc6debec04f8b4cd6f4c2394be upstream.
>
> Linus noticed odd declaration rules for pci_iounmap() in iomap.h and
> pci_iomap.h, where it dependend on either NO_GENERIC_PCI_IOPORT_MAP or
> GENERIC_IOMAP when CONFIG_PCI was disabled.
>
> Testing on parisc seems to indicate that we need pci_iounmap() only when
> CONFIG_PCI is enabled, so the declaration of pci_iounmap() can be moved
> cleanly into pci_iomap.h in sync with the declarations of pci_iomap().
>
> Link: https://lore.kernel.org/all/CAHk-=3DwjRrh98pZoQ+AzfWmsTZacWxTJKXZ9=
eKU2X_0+jM=3DO8nw@mail.gmail.com/
> Signed-off-by: Helge Deller <deller@gmx.de>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Fixes: 97a29d59fc22 ("[PARISC] fix compile break caused by iomap: make I=
OPORT/PCI mapping functions conditional")
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Ulrich Teichert <krypton@ulrich-teichert.org>
> Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   arch/parisc/lib/iomap.c         |    4 +++-
>   include/asm-generic/iomap.h     |   10 ----------
>   include/asm-generic/pci_iomap.h |    3 +++
>   3 files changed, 6 insertions(+), 11 deletions(-)
>
> --- a/arch/parisc/lib/iomap.c
> +++ b/arch/parisc/lib/iomap.c
> @@ -436,12 +436,15 @@ void ioport_unmap(void __iomem *addr)
>   	}
>   }
>
> +#ifdef CONFIG_PCI
>   void pci_iounmap(struct pci_dev *dev, void __iomem * addr)
>   {
>   	if (!INDIRECT_ADDR(addr)) {
>   		iounmap(addr);
>   	}
>   }
> +EXPORT_SYMBOL(pci_iounmap);
> +#endif
>
>   EXPORT_SYMBOL(ioread8);
>   EXPORT_SYMBOL(ioread16);
> @@ -461,4 +464,3 @@ EXPORT_SYMBOL(iowrite16_rep);
>   EXPORT_SYMBOL(iowrite32_rep);
>   EXPORT_SYMBOL(ioport_map);
>   EXPORT_SYMBOL(ioport_unmap);
> -EXPORT_SYMBOL(pci_iounmap);
> --- a/include/asm-generic/iomap.h
> +++ b/include/asm-generic/iomap.h
> @@ -78,16 +78,6 @@ extern void ioport_unmap(void __iomem *)
>   #define ioremap_wt ioremap_nocache
>   #endif
>
> -#ifdef CONFIG_PCI
> -/* Destroy a virtual mapping cookie for a PCI BAR (memory or IO) */
> -struct pci_dev;
> -extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
> -#elif defined(CONFIG_GENERIC_IOMAP)
> -struct pci_dev;
> -static inline void pci_iounmap(struct pci_dev *dev, void __iomem *addr)
> -{ }
> -#endif
> -
>   #include <asm-generic/pci_iomap.h>
>
>   #endif
> --- a/include/asm-generic/pci_iomap.h
> +++ b/include/asm-generic/pci_iomap.h
> @@ -22,6 +22,7 @@ extern void __iomem *pci_iomap_range(str
>   extern void __iomem *pci_iomap_wc_range(struct pci_dev *dev, int bar,
>   					unsigned long offset,
>   					unsigned long maxlen);
> +extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
>   /* Create a virtual mapping cookie for a port on a given PCI device.
>    * Do not call this directly, it exists to make it easier for architec=
tures
>    * to override */
> @@ -54,6 +55,8 @@ static inline void __iomem *pci_iomap_wc
>   {
>   	return NULL;
>   }
> +static inline void pci_iounmap(struct pci_dev *dev, void __iomem *addr)
> +{ }
>   #endif
>
>   #endif /* __ASM_GENERIC_IO_H */
>
>
> Patches currently in stable-queue which might be from deller@gmx.de are
>
> queue-4.9/parisc-declare-pci_iounmap-parisc-version-only-when-config_pci=
-enabled.patch
> queue-4.9/parisc-fix-crash-with-signals-and-alloca.patch
>

