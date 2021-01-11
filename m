Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7753F2F206F
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 21:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391249AbhAKUMS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 11 Jan 2021 15:12:18 -0500
Received: from aposti.net ([89.234.176.197]:54386 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390481AbhAKUMP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 15:12:15 -0500
Date:   Mon, 11 Jan 2021 20:11:20 +0000
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH] seccomp: Add missing return in non-void function
To:     Kees Cook <keescook@chromium.org>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Message-Id: <WEDSMQ.JSIS9ORBR57H1@crapouillou.net>
In-Reply-To: <202101111204.971BDEC@keescook>
References: <20210111172839.640914-1-paul@crapouillou.net>
        <202101111204.971BDEC@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le lun. 11 janv. 2021 à 12:04, Kees Cook <keescook@chromium.org> a 
écrit :
> On Mon, Jan 11, 2021 at 05:28:39PM +0000, Paul Cercueil wrote:
>>  We don't actually care about the value, since the kernel will panic
>>  before that; but a value should nonetheless be returned, otherwise 
>> the
>>  compiler will complain.
>> 
>>  Fixes: 8112c4f140fa ("seccomp: remove 2-phase API")
>>  Cc: stable@vger.kernel.org # 4.7+
>>  Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> 
> Ah, yes, thanks. What was the build config where this actually got
> exposed?

I did not try to get a minimum config to expose the issue; but see my 
full defconfig below [1].

That was when building for MIPS with GCC 10.2.

Cheers,
-Paul

[1]:
CONFIG_LOCALVERSION="-opendingux"
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_KERNEL_ZSTD=y
CONFIG_DEFAULT_HOSTNAME="opendingux"
# CONFIG_SWAP is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NO_HZ_IDLE=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_PREEMPT_VOLUNTARY=y
CONFIG_BLK_DEV_INITRD=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
# CONFIG_RD_ZSTD is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_LD_DEAD_CODE_DATA_ELIMINATION=y
# CONFIG_MULTIUSER is not set
# CONFIG_SGETMASK_SYSCALL is not set
# CONFIG_SYSFS_SYSCALL is not set
# CONFIG_FHANDLE is not set
# CONFIG_POSIX_TIMERS is not set
# CONFIG_BUG is not set
# CONFIG_BASE_FULL is not set
# CONFIG_FUTEX is not set
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
# CONFIG_SHMEM is not set
# CONFIG_AIO is not set
# CONFIG_IO_URING is not set
# CONFIG_ADVISE_SYSCALLS is not set
# CONFIG_MEMBARRIER is not set
# CONFIG_KALLSYMS is not set
# CONFIG_RSEQ is not set
CONFIG_EMBEDDED=y
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_COMPAT_BRK is not set
CONFIG_SLOB=y
# CONFIG_SLAB_MERGE_DEFAULT is not set
CONFIG_MACH_INGENIC_SOC=y
# CONFIG_MIPS_FP_SUPPORT is not set
CONFIG_HIGHMEM=y
CONFIG_HZ_100=y
CONFIG_MIPS_RAW_APPENDED_DTB=y
CONFIG_MIPS_CMDLINE_FROM_DTB=y
# CONFIG_SUSPEND is not set
# CONFIG_STACKPROTECTOR is not set
# CONFIG_COMPAT_32BIT_TIME is not set
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_MQ_IOSCHED_DEADLINE is not set
# CONFIG_MQ_IOSCHED_KYBER is not set
# CONFIG_COREDUMP is not set
CONFIG_CMA=y
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
# CONFIG_FW_LOADER is not set
# CONFIG_ALLOW_DEV_COREDUMP is not set
CONFIG_MTD=y
CONFIG_MTD_BLOCK=y
CONFIG_MTD_RAW_NAND=y
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=0
CONFIG_INPUT_EVDEV=y
# CONFIG_KEYBOARD_ATKBD is not set
CONFIG_KEYBOARD_GPIO=y
# CONFIG_INPUT_MOUSE is not set
# CONFIG_SERIO is not set
# CONFIG_CONSOLE_TRANSLATIONS is not set
# CONFIG_UNIX98_PTYS is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_LDISC_AUTOLOAD is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_DEVMEM is not set
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_GPIO=y
CONFIG_I2C_JZ4780=y
CONFIG_SPI=y
CONFIG_SPI_GPIO=y
CONFIG_CHARGER_GPIO=y
# CONFIG_HWMON is not set
CONFIG_WATCHDOG=y
CONFIG_JZ4740_WDT=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_ACT8865=y
CONFIG_DRM=y
CONFIG_DRM_MIPI_DBI_SPI=y
CONFIG_DRM_PANEL_AUO_A030JTN01=y
CONFIG_DRM_PANEL_ABT_Y030XX067A=y
CONFIG_DRM_PANEL_SIMPLE=y
CONFIG_DRM_PANEL_INNOLUX_EJ030NA=y
CONFIG_DRM_PANEL_NEWVISION_NV3052C=y
CONFIG_DRM_PANEL_NOVATEK_NT39016=y
CONFIG_DRM_ITE_IT6610=y
CONFIG_DRM_ITE_IT66121=y
CONFIG_DRM_INGENIC=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_PWM=y
# CONFIG_VGA_CONSOLE is not set
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_USB_CONN_GPIO=y
CONFIG_USB_MUSB_HDRC=y
CONFIG_USB_MUSB_JZ4740=y
CONFIG_USB_INVENTRA_DMA=y
CONFIG_USB_GADGET=y
CONFIG_USB_CONFIGFS=y
CONFIG_USB_CONFIGFS_F_FS=y
CONFIG_MMC=y
# CONFIG_PWRSEQ_EMMC is not set
# CONFIG_PWRSEQ_SIMPLE is not set
CONFIG_MMC_JZ4740=y
CONFIG_MMC_HSQ=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
CONFIG_LEDS_GPIO=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_SYSTOHC is not set
# CONFIG_RTC_NVMEM is not set
# CONFIG_RTC_INTF_SYSFS is not set
# CONFIG_RTC_INTF_PROC is not set
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_JZ4740=y
CONFIG_DMADEVICES=y
CONFIG_DMA_JZ4780=y
# CONFIG_VIRTIO_MENU is not set
# CONFIG_VHOST_MENU is not set
# CONFIG_MIPS_PLATFORM_DEVICES is not set
# CONFIG_INGENIC_CGU_JZ4780 is not set
# CONFIG_INGENIC_CGU_X1000 is not set
# CONFIG_INGENIC_CGU_X1830 is not set
CONFIG_INGENIC_OST=y
# CONFIG_IOMMU_SUPPORT is not set
CONFIG_MEMORY=y
CONFIG_JZ4780_NEMC=y
CONFIG_PWM=y
CONFIG_PWM_JZ4740=y
CONFIG_PHY_INGENIC_USB=y
# CONFIG_NVMEM is not set
CONFIG_EXT4_FS=y
CONFIG_F2FS_FS=y
# CONFIG_F2FS_STAT_FS is not set
# CONFIG_F2FS_FS_XATTR is not set
CONFIG_F2FS_FS_COMPRESSION=y
# CONFIG_F2FS_FS_LZO is not set
# CONFIG_F2FS_FS_LZ4 is not set
# CONFIG_FILE_LOCKING is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
CONFIG_VFAT_FS=y
CONFIG_UBIFS_FS=y
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
# CONFIG_UBIFS_FS_XATTR is not set
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_SYMBOLIC_ERRNAME is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
# CONFIG_SECTION_MISMATCH_WARN_ONLY is not set
# CONFIG_DEBUG_MISC is not set
# CONFIG_FTRACE is not set
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE="root=/dev/mmcblk0p1 rootfstype=vfat rootwait ro 
init=/mininit-syspart"
# CONFIG_RUNTIME_TESTING_MENU is not set


