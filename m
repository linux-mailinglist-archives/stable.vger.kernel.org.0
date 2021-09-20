Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C74541112B
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 10:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbhITIpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 04:45:50 -0400
Received: from mout.gmx.net ([212.227.17.20]:49887 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230053AbhITIpt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 04:45:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1632127443;
        bh=seCpYMnNuQT+jEEjz73RSVjuPxzfXPmWMJCCiyaz2MY=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=YkHHCy8KxZNjhOAcW0qJJIVQ9paFxp0kSpABvU15FdJT2BIhZnZn/GuSX6ac8SLPA
         0y42j0HEW3xNwfdBXhKTKVbzn89tNzl4DvY2KoC12rJ7/3//uiZPoMQGq+2ma89UgF
         4c7m77EJ+4Ni+nc3Phv/hXY1hduEzmG0A4czJu0Q=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.20.59] ([92.116.139.149]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MIMbU-1mgaut1I84-00EJKp; Mon, 20
 Sep 2021 10:44:03 +0200
Subject: Re: Patch "parisc: Declare pci_iounmap() parisc version only when
 CONFIG_PCI enabled" has been added to the 5.14-stable tree
To:     gregkh@linuxfoundation.org, James.Bottomley@hansenpartnership.com,
        arnd@arndb.de, krypton@ulrich-teichert.org, linux@roeck-us.net,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     stable-commits@vger.kernel.org
References: <1632125867143104@kroah.com>
From:   Helge Deller <deller@gmx.de>
Message-ID: <4342aded-0ea5-6221-b48a-9724b1a7f364@gmx.de>
Date:   Mon, 20 Sep 2021 10:44:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1632125867143104@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:z/SWRwtfPKPeIaaUiiat2AyHRdIPUVO61VuaS0aKAreEaWjVUFW
 dqVfP9ElbFveHwzhc8pKu5aXSqJtEKShA3r9/VAAAPYj9hFfjjZz9sqrJp7Wlo804iZ63yA
 poeCoLDmG0Kpc8dnbn8dEyaZxplxsyLNosoFX6x3i9j0k1Xi6Ilj3TB9nZWkOEvW+XubTtz
 D/F09ilyGcMqhYoc0hUvg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ylAn30g8o7I=:TwvyS3g67B2zufv03myJOb
 eKnc8ZmV/DvtC+UtDDMWpeUq+w+Nli0SMVSDpL251PcELdJHbth0s1KyygkBLv4iGCvD/PNsT
 mceuWs5ImJ4heczJPB2JktwKeergBu0q0BGlQu/z7XfSjjmFB4tAOg5hIKxekjSwktIX6Qepc
 3VHw/uRPlQYpxcnr0XLwv63s+Z7JtKcooJVgqObNkMCXR2q3LSYMi9q5138LdhAXXYkL5pwmZ
 3Bf0Gvl9wfES9UB/0C/PXaD1Qumk7azlMMwOt4f4rpiEOzLAwitEBl4zomMAQ9UE9DSKx91HI
 Pk5MNVhYSPXjFz94bWrhwLjcbvo48WdvjcSTyBXUBw6Idk/yUq4HsYvkR+Px3/n42lTcu0+xy
 XX2Wi5XJVXHzIVESC8bjaUH9D6a/IzCTtg1edx7xvtyH3PbM+KGnv5YwEOssfbWrNNzc/xNPg
 CW432EsRzpkQHjolyCI2vb5c4swhsurZw+8JVED5OnHJWQGPWm5vbw/apbgAu1dx6ZQ4ZnnFv
 l4VNWul0ZWksGqvDcHck9169sRLuqSMMfycbNwCd4z/vc0wm42H1KfOHbxJpZFFJ7kDhEaczp
 /weZ6g0Fz4G8EZnx35BWfZc+xzRzt0ueI9zDwz07qD3LU+AiB/u2ak/ZF8VJ/9mGTAlhTLLgS
 6Zv1Z032hsavdgp3FxiHGXj4VGRAm/7SJzprCh2NeFOEXIsG1Tz6wLcFRojsVZwAN620ksDjA
 LHws5aEF1u39Q/Vl41KlZ6DQGt/OEEySkvqjhp1ST+LBXpqymEOfz5fwhu7k5zkyF2M95J6/+
 btGDrZWBBnSrWYDjoZ7wOM6ZxeawJoBv3hYW/9feBAvk6gKAuMNkZAiXQPJVUtNtjJxHYyVBy
 Wv6IwLhTK2bPVulow3ju27yDnUuFflGfhXSTJ6YhV+gbl0lBFlPqH6mKx9ErMfh7cdNFtZ5IH
 m627VFnff8L0iTHb3VkOBTKsCkNrFPcPFEYZD8JPY7bWyuvsZMQdrTfKDjkJO7eYYIURTIqRC
 70/U+2awtTLzB0Sf7zFbWAZyClS82D3ixp/oyls22pAuY6Y2O9/ssHKiHL+P8PDwxBOd/T5Wb
 lvIUXaimGHQFUE=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/20/21 10:17 AM, gregkh@linuxfoundation.org wrote:
>
> This is a note to let you know that I've just added the patch titled
>
>      parisc: Declare pci_iounmap() parisc version only when CONFIG_PCI e=
nabled
>
> to the 5.14-stable tree which can be found at:
>      http://www.kernel.org/git/?p=3Dlinux/kernel/git/stable/stable-queue=
.git;a=3Dsummary
>
> The filename of the patch is:
>       parisc-declare-pci_iounmap-parisc-version-only-when-config_pci-ena=
bled.patch
> and it can be found in the queue-5.14 subdirectory.
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
> @@ -513,12 +513,15 @@ void ioport_unmap(void __iomem *addr)
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
> @@ -544,4 +547,3 @@ EXPORT_SYMBOL(iowrite16_rep);
>   EXPORT_SYMBOL(iowrite32_rep);
>   EXPORT_SYMBOL(ioport_map);
>   EXPORT_SYMBOL(ioport_unmap);
> -EXPORT_SYMBOL(pci_iounmap);
> --- a/include/asm-generic/iomap.h
> +++ b/include/asm-generic/iomap.h
> @@ -110,16 +110,6 @@ static inline void __iomem *ioremap_np(p
>   }
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
> @@ -18,6 +18,7 @@ extern void __iomem *pci_iomap_range(str
>   extern void __iomem *pci_iomap_wc_range(struct pci_dev *dev, int bar,
>   					unsigned long offset,
>   					unsigned long maxlen);
> +extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
>   /* Create a virtual mapping cookie for a port on a given PCI device.
>    * Do not call this directly, it exists to make it easier for architec=
tures
>    * to override */
> @@ -50,6 +51,8 @@ static inline void __iomem *pci_iomap_wc
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
> queue-5.14/parisc-declare-pci_iounmap-parisc-version-only-when-config_pc=
i-enabled.patch
>

