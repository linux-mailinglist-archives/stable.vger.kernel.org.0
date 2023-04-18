Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABA886E6592
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 15:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbjDRNLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 09:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232383AbjDRNLR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 09:11:17 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E433515A25
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 06:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681823473; x=1713359473;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=15bpy74ikNgMqPIM0raKdUnUd0of9O0foBfRD2t7dAs=;
  b=eUmhsLw6F1iYlayfJyWbspjfENVW86wJRCgZgynKpb0tEt8i0fpQuOTj
   GHeVslR/7p9YQ1F6+5Es/+TDs07T3aBjgdjsTu406eLwRrZBLufsSWpYO
   WoaZpzs0ZUyDupxxvKKsj4k129NuzcbHziu+ct7xVOCG0SW7REmgMnFKW
   IZBT3tUqqAtC2rdMxXCJ/MAMiYGHmethrSYKeFx1FNACM3oJeUfJglV1g
   m2agdVPzpvhFqo4kT2L1HOnTe0qqdibOCBagD7Ccoqzjj5ly5Q8IM2ft+
   A7xLCTdmys5tkw9L7TeN6ixM/Los96/tKi7Ie8D3sJuLSH/aQYN4R60ak
   g==;
X-IronPort-AV: E=Sophos;i="5.99,207,1677567600"; 
   d="asc'?scan'208";a="211013692"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Apr 2023 06:11:12 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 18 Apr 2023 06:11:11 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 18 Apr 2023 06:11:10 -0700
Date:   Tue, 18 Apr 2023 14:10:54 +0100
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <patches@lists.linux.dev>,
        Alexandre Ghiti <alexghiti@rivosinc.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 129/134] riscv: Move early dtb mapping into the
 fixmap region
Message-ID: <20230418-tactile-cocoa-4242e87bf994@wendy>
References: <20230418120313.001025904@linuxfoundation.org>
 <20230418120317.673170852@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HQeLRL0T/HY+c+fT"
Content-Disposition: inline
In-Reply-To: <20230418120317.673170852@linuxfoundation.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--HQeLRL0T/HY+c+fT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 18, 2023 at 02:23:05PM +0200, Greg Kroah-Hartman wrote:
> From: Alexandre Ghiti <alexghiti@rivosinc.com>
>=20
> [ Upstream commit ef69d2559fe91f23d27a3d6fd640b5641787d22e ]

Hey Greg,

Please check out <e3a6656c-0ec4-9d54-b262-1af08c292ed5@microchip.com>
(I can't find a lore link for stable-commit@vger stuff)
as I am not sure whether it is okay to backport this in isolation.

Cheers,
Conor.

>=20
> riscv establishes 2 virtual mappings:
>=20
> - early_pg_dir maps the kernel which allows to discover the system
>   memory
> - swapper_pg_dir installs the final mapping (linear mapping included)
>=20
> We used to map the dtb in early_pg_dir using DTB_EARLY_BASE_VA, and this
> mapping was not carried over in swapper_pg_dir. It happens that
> early_init_fdt_scan_reserved_mem() must be called before swapper_pg_dir is
> setup otherwise we could allocate reserved memory defined in the dtb.
> And this function initializes reserved_mem variable with addresses that
> lie in the early_pg_dir dtb mapping: when those addresses are reused
> with swapper_pg_dir, this mapping does not exist and then we trap.
>=20
> The previous "fix" was incorrect as early_init_fdt_scan_reserved_mem()
> must be called before swapper_pg_dir is set up otherwise we could
> allocate in reserved memory defined in the dtb.
>=20
> So move the dtb mapping in the fixmap region which is established in
> early_pg_dir and handed over to swapper_pg_dir.
>=20
> Fixes: 922b0375fc93 ("riscv: Fix memblock reservation for device tree blo=
b")
> Fixes: 8f3a2b4a96dc ("RISC-V: Move DT mapping outof fixmap")
> Fixes: 50e63dd8ed92 ("riscv: fix reserved memory setup")
> Reported-by: Conor Dooley <conor.dooley@microchip.com>
> Link: https://lore.kernel.org/all/f8e67f82-103d-156c-deb0-d6d6e2756f5e@mi=
crochip.com/
> Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> Tested-by: Conor Dooley <conor.dooley@microchip.com>
> Link: https://lore.kernel.org/r/20230329081932.79831-2-alexghiti@rivosinc=
=2Ecom
> Cc: stable@vger.kernel.org
> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  Documentation/riscv/vm-layout.rst |  6 +--
>  arch/riscv/include/asm/fixmap.h   |  8 ++++
>  arch/riscv/include/asm/pgtable.h  |  8 +++-
>  arch/riscv/kernel/setup.c         |  1 -
>  arch/riscv/mm/init.c              | 61 +++++++++++++++++--------------
>  5 files changed, 51 insertions(+), 33 deletions(-)
>=20
> diff --git a/Documentation/riscv/vm-layout.rst b/Documentation/riscv/vm-l=
ayout.rst
> index 3be44e74ec5d6..5462c84f4723f 100644
> --- a/Documentation/riscv/vm-layout.rst
> +++ b/Documentation/riscv/vm-layout.rst
> @@ -47,7 +47,7 @@ RISC-V Linux Kernel SV39
>                                                                | Kernel-s=
pace virtual memory, shared between all processes:
>    ____________________________________________________________|_________=
__________________________________________________
>                      |            |                  |         |
> -   ffffffc6fee00000 | -228    GB | ffffffc6feffffff |    2 MB | fixmap
> +   ffffffc6fea00000 | -228    GB | ffffffc6feffffff |    6 MB | fixmap
>     ffffffc6ff000000 | -228    GB | ffffffc6ffffffff |   16 MB | PCI io
>     ffffffc700000000 | -228    GB | ffffffc7ffffffff |    4 GB | vmemmap
>     ffffffc800000000 | -224    GB | ffffffd7ffffffff |   64 GB | vmalloc/=
ioremap space
> @@ -83,7 +83,7 @@ RISC-V Linux Kernel SV48
>                                                                | Kernel-s=
pace virtual memory, shared between all processes:
>    ____________________________________________________________|_________=
__________________________________________________
>                      |            |                  |         |
> -   ffff8d7ffee00000 |  -114.5 TB | ffff8d7ffeffffff |    2 MB | fixmap
> +   ffff8d7ffea00000 |  -114.5 TB | ffff8d7ffeffffff |    6 MB | fixmap
>     ffff8d7fff000000 |  -114.5 TB | ffff8d7fffffffff |   16 MB | PCI io
>     ffff8d8000000000 |  -114.5 TB | ffff8f7fffffffff |    2 TB | vmemmap
>     ffff8f8000000000 |  -112.5 TB | ffffaf7fffffffff |   32 TB | vmalloc/=
ioremap space
> @@ -119,7 +119,7 @@ RISC-V Linux Kernel SV57
>                                                                | Kernel-s=
pace virtual memory, shared between all processes:
>    ____________________________________________________________|_________=
__________________________________________________
>                      |            |                  |         |
> -   ff1bfffffee00000 | -57     PB | ff1bfffffeffffff |    2 MB | fixmap
> +   ff1bfffffea00000 | -57     PB | ff1bfffffeffffff |    6 MB | fixmap
>     ff1bffffff000000 | -57     PB | ff1bffffffffffff |   16 MB | PCI io
>     ff1c000000000000 | -57     PB | ff1fffffffffffff |    1 PB | vmemmap
>     ff20000000000000 | -56     PB | ff5fffffffffffff |   16 PB | vmalloc/=
ioremap space
> diff --git a/arch/riscv/include/asm/fixmap.h b/arch/riscv/include/asm/fix=
map.h
> index 5c3e7b97fcc6f..0a55099bb7349 100644
> --- a/arch/riscv/include/asm/fixmap.h
> +++ b/arch/riscv/include/asm/fixmap.h
> @@ -22,6 +22,14 @@
>   */
>  enum fixed_addresses {
>  	FIX_HOLE,
> +	/*
> +	 * The fdt fixmap mapping must be PMD aligned and will be mapped
> +	 * using PMD entries in fixmap_pmd in 64-bit and a PGD entry in 32-bit.
> +	 */
> +	FIX_FDT_END,
> +	FIX_FDT =3D FIX_FDT_END + FIX_FDT_SIZE / PAGE_SIZE - 1,
> +
> +	/* Below fixmaps will be mapped using fixmap_pte */
>  	FIX_PTE,
>  	FIX_PMD,
>  	FIX_PUD,
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pg=
table.h
> index 92ec2d9d7273f..2aeaf8e3a4ab0 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -87,9 +87,13 @@
> =20
>  #define FIXADDR_TOP      PCI_IO_START
>  #ifdef CONFIG_64BIT
> -#define FIXADDR_SIZE     PMD_SIZE
> +#define MAX_FDT_SIZE	 PMD_SIZE
> +#define FIX_FDT_SIZE	 (MAX_FDT_SIZE + SZ_2M)
> +#define FIXADDR_SIZE     (PMD_SIZE + FIX_FDT_SIZE)
>  #else
> -#define FIXADDR_SIZE     PGDIR_SIZE
> +#define MAX_FDT_SIZE	 PGDIR_SIZE
> +#define FIX_FDT_SIZE	 MAX_FDT_SIZE
> +#define FIXADDR_SIZE     (PGDIR_SIZE + FIX_FDT_SIZE)
>  #endif
>  #define FIXADDR_START    (FIXADDR_TOP - FIXADDR_SIZE)
> =20
> diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
> index d4a12233e728d..2acf51c235673 100644
> --- a/arch/riscv/kernel/setup.c
> +++ b/arch/riscv/kernel/setup.c
> @@ -280,7 +280,6 @@ void __init setup_arch(char **cmdline_p)
>  #else
>  	unflatten_device_tree();
>  #endif
> -	early_init_fdt_scan_reserved_mem();
>  	misc_mem_init();
> =20
>  	init_resources();
> diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
> index 50a1b6edd4918..5570c52deb0b5 100644
> --- a/arch/riscv/mm/init.c
> +++ b/arch/riscv/mm/init.c
> @@ -57,7 +57,6 @@ unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsign=
ed long)]
>  EXPORT_SYMBOL(empty_zero_page);
> =20
>  extern char _start[];
> -#define DTB_EARLY_BASE_VA      PGDIR_SIZE
>  void *_dtb_early_va __initdata;
>  uintptr_t _dtb_early_pa __initdata;
> =20
> @@ -236,6 +235,14 @@ static void __init setup_bootmem(void)
>  	set_max_mapnr(max_low_pfn - ARCH_PFN_OFFSET);
> =20
>  	reserve_initrd_mem();
> +
> +	/*
> +	 * No allocation should be done before reserving the memory as defined
> +	 * in the device tree, otherwise the allocation could end up in a
> +	 * reserved region.
> +	 */
> +	early_init_fdt_scan_reserved_mem();
> +
>  	/*
>  	 * If DTB is built in, no need to reserve its memblock.
>  	 * Otherwise, do reserve it but avoid using
> @@ -279,9 +286,6 @@ pgd_t trampoline_pg_dir[PTRS_PER_PGD] __page_aligned_=
bss;
>  static pte_t fixmap_pte[PTRS_PER_PTE] __page_aligned_bss;
> =20
>  pgd_t early_pg_dir[PTRS_PER_PGD] __initdata __aligned(PAGE_SIZE);
> -static p4d_t __maybe_unused early_dtb_p4d[PTRS_PER_P4D] __initdata __ali=
gned(PAGE_SIZE);
> -static pud_t __maybe_unused early_dtb_pud[PTRS_PER_PUD] __initdata __ali=
gned(PAGE_SIZE);
> -static pmd_t __maybe_unused early_dtb_pmd[PTRS_PER_PMD] __initdata __ali=
gned(PAGE_SIZE);
> =20
>  #ifdef CONFIG_XIP_KERNEL
>  #define pt_ops			(*(struct pt_alloc_ops *)XIP_FIXUP(&pt_ops))
> @@ -626,9 +630,6 @@ static void __init create_p4d_mapping(p4d_t *p4dp,
>  #define trampoline_pgd_next	(pgtable_l5_enabled ?			\
>  		(uintptr_t)trampoline_p4d : (pgtable_l4_enabled ?	\
>  		(uintptr_t)trampoline_pud : (uintptr_t)trampoline_pmd))
> -#define early_dtb_pgd_next	(pgtable_l5_enabled ?			\
> -		(uintptr_t)early_dtb_p4d : (pgtable_l4_enabled ?	\
> -		(uintptr_t)early_dtb_pud : (uintptr_t)early_dtb_pmd))
>  #else
>  #define pgd_next_t		pte_t
>  #define alloc_pgd_next(__va)	pt_ops.alloc_pte(__va)
> @@ -636,7 +637,6 @@ static void __init create_p4d_mapping(p4d_t *p4dp,
>  #define create_pgd_next_mapping(__nextp, __va, __pa, __sz, __prot)	\
>  	create_pte_mapping(__nextp, __va, __pa, __sz, __prot)
>  #define fixmap_pgd_next		((uintptr_t)fixmap_pte)
> -#define early_dtb_pgd_next	((uintptr_t)early_dtb_pmd)
>  #define create_p4d_mapping(__pmdp, __va, __pa, __sz, __prot) do {} while=
(0)
>  #define create_pud_mapping(__pmdp, __va, __pa, __sz, __prot) do {} while=
(0)
>  #define create_pmd_mapping(__pmdp, __va, __pa, __sz, __prot) do {} while=
(0)
> @@ -859,32 +859,28 @@ static void __init create_kernel_page_table(pgd_t *=
pgdir, bool early)
>   * this means 2 PMD entries whereas for 32-bit kernel, this is only 1 PG=
DIR
>   * entry.
>   */
> -static void __init create_fdt_early_page_table(pgd_t *pgdir, uintptr_t d=
tb_pa)
> +static void __init create_fdt_early_page_table(pgd_t *pgdir,
> +					       uintptr_t fix_fdt_va,
> +					       uintptr_t dtb_pa)
>  {
> -#ifndef CONFIG_BUILTIN_DTB
>  	uintptr_t pa =3D dtb_pa & ~(PMD_SIZE - 1);
> =20
> -	create_pgd_mapping(early_pg_dir, DTB_EARLY_BASE_VA,
> -			   IS_ENABLED(CONFIG_64BIT) ? early_dtb_pgd_next : pa,
> -			   PGDIR_SIZE,
> -			   IS_ENABLED(CONFIG_64BIT) ? PAGE_TABLE : PAGE_KERNEL);
> -
> -	if (pgtable_l5_enabled)
> -		create_p4d_mapping(early_dtb_p4d, DTB_EARLY_BASE_VA,
> -				   (uintptr_t)early_dtb_pud, P4D_SIZE, PAGE_TABLE);
> -
> -	if (pgtable_l4_enabled)
> -		create_pud_mapping(early_dtb_pud, DTB_EARLY_BASE_VA,
> -				   (uintptr_t)early_dtb_pmd, PUD_SIZE, PAGE_TABLE);
> +#ifndef CONFIG_BUILTIN_DTB
> +	/* Make sure the fdt fixmap address is always aligned on PMD size */
> +	BUILD_BUG_ON(FIX_FDT % (PMD_SIZE / PAGE_SIZE));
> =20
> -	if (IS_ENABLED(CONFIG_64BIT)) {
> -		create_pmd_mapping(early_dtb_pmd, DTB_EARLY_BASE_VA,
> +	/* In 32-bit only, the fdt lies in its own PGD */
> +	if (!IS_ENABLED(CONFIG_64BIT)) {
> +		create_pgd_mapping(early_pg_dir, fix_fdt_va,
> +				   pa, MAX_FDT_SIZE, PAGE_KERNEL);
> +	} else {
> +		create_pmd_mapping(fixmap_pmd, fix_fdt_va,
>  				   pa, PMD_SIZE, PAGE_KERNEL);
> -		create_pmd_mapping(early_dtb_pmd, DTB_EARLY_BASE_VA + PMD_SIZE,
> +		create_pmd_mapping(fixmap_pmd, fix_fdt_va + PMD_SIZE,
>  				   pa + PMD_SIZE, PMD_SIZE, PAGE_KERNEL);
>  	}
> =20
> -	dtb_early_va =3D (void *)DTB_EARLY_BASE_VA + (dtb_pa & (PMD_SIZE - 1));
> +	dtb_early_va =3D (void *)fix_fdt_va + (dtb_pa & (PMD_SIZE - 1));
>  #else
>  	/*
>  	 * For 64-bit kernel, __va can't be used since it would return a linear
> @@ -1054,7 +1050,8 @@ asmlinkage void __init setup_vm(uintptr_t dtb_pa)
>  	create_kernel_page_table(early_pg_dir, true);
> =20
>  	/* Setup early mapping for FDT early scan */
> -	create_fdt_early_page_table(early_pg_dir, dtb_pa);
> +	create_fdt_early_page_table(early_pg_dir,
> +				    __fix_to_virt(FIX_FDT), dtb_pa);
> =20
>  	/*
>  	 * Bootime fixmap only can handle PMD_SIZE mapping. Thus, boot-ioremap
> @@ -1096,6 +1093,16 @@ static void __init setup_vm_final(void)
>  	u64 i;
> =20
>  	/* Setup swapper PGD for fixmap */
> +#if !defined(CONFIG_64BIT)
> +	/*
> +	 * In 32-bit, the device tree lies in a pgd entry, so it must be copied
> +	 * directly in swapper_pg_dir in addition to the pgd entry that points
> +	 * to fixmap_pte.
> +	 */
> +	unsigned long idx =3D pgd_index(__fix_to_virt(FIX_FDT));
> +
> +	set_pgd(&swapper_pg_dir[idx], early_pg_dir[idx]);
> +#endif
>  	create_pgd_mapping(swapper_pg_dir, FIXADDR_START,
>  			   __pa_symbol(fixmap_pgd_next),
>  			   PGDIR_SIZE, PAGE_TABLE);
> --=20
> 2.39.2
>=20
>=20
>=20

--HQeLRL0T/HY+c+fT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZD6W3gAKCRB4tDGHoIJi
0n4jAPkBNaJEves6c2aFFfaQoy01w5IEzTZCiboSdHzHtltGhwD/e/RxwhujiNIj
wan4iSgCySfeg2ph6P9aBV+F+n8vVwk=
=DP/c
-----END PGP SIGNATURE-----

--HQeLRL0T/HY+c+fT--
