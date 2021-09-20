Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F17411146
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 10:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235959AbhITIr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 04:47:26 -0400
Received: from mout.gmx.net ([212.227.17.21]:53515 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230488AbhITIr0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 04:47:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1632127543;
        bh=8wHa2v+XCpK+a8HTrvVCY/QP7fUklcA0VYbvY9SaqmE=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=ZUEdppxmzyKiaCncqtuTrgbVOMAw8PrnO+/PKqKKB+d4qE+p5cazlJ0UiL2pvLS7+
         rQ5P8glBnKXZ+ETKQuEXJzvH+Y8E037MWbqX8SlFcHPGt/h9m8B3mjG7uGmTv8kgDI
         1DwqX7WXlHapEmIiMh/03eMDRohsEUKkYUhrVAT4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.20.59] ([92.116.139.149]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MAOJP-1mZgmC16s7-00BtjF; Mon, 20
 Sep 2021 10:45:43 +0200
Subject: Re: Patch "parisc: Declare pci_iounmap() parisc version only when
 CONFIG_PCI enabled" has been added to the 4.4-stable tree
To:     gregkh@linuxfoundation.org, James.Bottomley@hansenpartnership.com,
        arnd@arndb.de, krypton@ulrich-teichert.org, linux@roeck-us.net,
        torvalds@linux-foundation.org, stable <stable@vger.kernel.org>
Cc:     stable-commits@vger.kernel.org
References: <163212536414258@kroah.com>
From:   Helge Deller <deller@gmx.de>
Message-ID: <8b36c2b6-3f5e-2f87-e45f-262d0b93b071@gmx.de>
Date:   Mon, 20 Sep 2021 10:45:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <163212536414258@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:i8OMhYvsToYxEb40YUieYeIgZfJJu3g2ZgkYXiv0mWe4YCLofus
 aG/pBR4ILlhutHd0qxdoGXbDgCnHQFtir/eGR0pTQIxux0TW1UsUcXC014MFpXOhL31zOLa
 BClHDjS7+l25eOsDgSzEYFFyIhuwvKk2BcmCRZdl/t8gaELVzOZQZ3VO6ZtZQILL9KwzzFK
 rc7Xhqps7fXnCthbwoU6w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:1yiZaWUdhxI=:9Y5yexTjn1ke9Ft8SIknxQ
 reUxep/W+DE7z4k+G/xN4AXiJ9fxcGCn8p+Hw9UraJ7pFJu9St/gqHHVaaktwmp35vcb0txah
 th5MAYDMb9n5iLsqUsowr2yacOwz0imLnnZsIdtCL5MYVxiLeU4GMygMt1E9QNd/ORCXTX/j4
 N91Mm3MN7t93TuQGSzjMLWWesix8/ZoYCUdYAIdFZ5Zn48GJ+Fte36hNzLTFYfZL83XkrCW/W
 xZ9KiOjrJzFcAPz2wIZCcZqizEDNwp07k+NRL15P2CETauezvgIxDcLnHB/MGUe4GnpQeWg7n
 SFuNlhZqxMgjtRv5fhNPNTTwuTmq3EXRqiPiazeKj3LSQk68BtX+ArXKG1/g9D78pBu6/c6Ax
 Y0Sb1vS+NELJGhyhdCAZSC6oNA3PoE16wDZyTy3Mmx+LdCUpNA+lvZw8sYLFTIQLnybKRULtr
 TJK3ffVnAkB4CZgs14df0C/6vUQF05HM9MBS7QU0CFjwbKPyNy84iq7/adIQCTv78jiqZQC89
 swAyfUDlhzrStuCiO68ARRKeUuH/AVcNMXpi/A/U+fbtdOijDbpcnZocljJ+glXd8G1Zfrjqc
 VQ4l4rtt9IVwpkeVDw+Ny/yUtfAqVBDbBUYJ7JCnt5v/9I7RJnnNgQiGtYIp5L55Sb9d0a9eS
 g7N0zzBGhFpd9Z1KPADc4+JLBshKU18PRq+i16kBBNglme2q4rUKbcRVebroCP28PG9K9YCZR
 8hxuQ9wf1RbIcdt/niKPCrN6iIurnypalIrwrAOWI5g4GHUvl5jhGWiOHPIuURrqr906RSxq1
 yVfUcaAYSI3aLTcotYu+uvQgsJI07zPnUsvwJ9gFwZUGOWHYJGXBMz3ENDVJcQXCMj5ODo5aq
 veBUUbYgW1lkLPO4BYBqg9E5c6BRYHuwhSdkg8vllnzphtvNH1BOKuQ7eDaONNcTY4XpJLQXm
 pF78KSJ3UVrU2HpSXY3sbRdTQWB4fg+QxFHaRp5cYk57ItbzAz8esBLA3Q+/MBo1ygnZYiQ8r
 dMqOREeo6O8EbvVCN19bwjgL4nVI+P3Vam+VTd75oPaSeDytmpsQDPmVoyqUj/zjlAEnl5sjw
 ng2aDvhMhiAEdE=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/20/21 10:09 AM, gregkh@linuxfoundation.org wrote:
>
> This is a note to let you know that I've just added the patch titled
>
>      parisc: Declare pci_iounmap() parisc version only when CONFIG_PCI e=
nabled
>
> to the 4.4-stable tree which can be found at:
>      http://www.kernel.org/git/?p=3Dlinux/kernel/git/stable/stable-queue=
.git;a=3Dsummary
>
> The filename of the patch is:
>       parisc-declare-pci_iounmap-parisc-version-only-when-config_pci-ena=
bled.patch
> and it can be found in the queue-4.4 subdirectory.
>
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

Please don't apply to 4.4 (or any stable tree yet).


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
> @@ -70,16 +70,6 @@ extern void ioport_unmap(void __iomem *)
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
> queue-4.4/parisc-declare-pci_iounmap-parisc-version-only-when-config_pci=
-enabled.patch
> queue-4.4/parisc-fix-crash-with-signals-and-alloca.patch
>

