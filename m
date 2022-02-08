Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B614D4ADB7B
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 15:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351484AbiBHOqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 09:46:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378360AbiBHOqm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 09:46:42 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C3EC061578
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 06:46:40 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 114F73201FDA;
        Tue,  8 Feb 2022 09:46:37 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 08 Feb 2022 09:46:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=zGLZkMpFhFkuqi
        h4IHH6JoQD/3TFhxLf6cicqbU/Wxo=; b=mrI9pmPNRY0800y1uKrNhtqVFl4HUL
        IcKPtRP9LOgbAElvDYXz07EnNcOaK9TFdzHpji4J2lzdto04PxI6GrG5yXjvoRvX
        c3ARvrzVqImdtasqMFRQhmYczck+wBZe105i05wWibK4zaSbf6vrZRSbUpaK/hjk
        aYX+mVNBqLU7igCTUaTwRTwdN9rBATZB/IaRPf2eDQDlfQL5pdwLE+HfIk9oirx1
        tKXuPMS/Yw8DLTPfXEbsUvVmZg7y7t/hLBNiNruSAPmFEYIjoyd5pAcRFqk25f9Q
        twdVjzLUaf6GcFWjFej1+b4cYVuyMNsFeHRFbNG3hwYn2qyHMGr+15+w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=zGLZkMpFhFkuqih4IHH6JoQD/3TFhxLf6cicqbU/W
        xo=; b=TBBUHa4aOAMM/Fad2J9UVcPDOVUYCgG25icjh+cwgvhv5005u0tiDxICQ
        c9X6VtUpnp33gVnqPghW3Ess62vJPdEXXgdAKW30qSCbbI2A8Z/e0hkc12tQeuDi
        uEyYObogLIaupawOwH4G3CEQSidmetqthiO3rwhc3qhrjtVqXv81GKeELjKJg+t6
        eDqMF+FdGM40WxuzF2puGStFxEH5lhB1hwaZYGdblvDnSNFjfoEoOuQdsX3zSavs
        0IJ5q020Qho6sKuP5b6ULfEqXvM/bAAEIDVavI6GJEBvefJLjI077b45HkcW/h9M
        9d5+edNzo5Jxz528vlO5WeNgcBykw==
X-ME-Sender: <xms:TYICYlKGF6iY-h5HyVOG4x3kb0B7K_U85PieW9m0zGvCJutHvn8U6A>
    <xme:TYICYhL5P-xW97aRL8WtHCk6Vjk88m8DyC9XfXJCA50eOF9qLtr2WLvqrNLjNnV3g
    MygX8PBm-F23zClhWU>
X-ME-Received: <xmr:TYICYtuQ-0Bh5PgZ9Od3ECWJ_GKfWoHXsx95tA4wkwJxyOxL8X0cK6BgP8s0mn0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheejgdeihecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkffggfgfuvfhfhfgjtgfgsehtkeertddtfeejnecuhfhrohhmpeflihgrgihu
    nhcujggrnhhguceojhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomheqnecugg
    ftrfgrthhtvghrnhepheeiuddvvefhkeejfedttdekieethfdukedvieeuueelgfelieej
    geehvdekudelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepjhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomh
X-ME-Proxy: <xmx:TYICYmbbCGinEdwQk3c6LUDQj5SPKg-UAKpRGrNedMerVnVRCZ4MyA>
    <xmx:TYICYsbSLjOgxaL18-hfozM8XT8UPOu2PiKkTo-I8qKIkvisTLCbAQ>
    <xmx:TYICYqA-vF_A_hiPwTg7YRBJfbVR-V0Ib0CZHDxy5ojF6skg09Scow>
    <xmx:TYICYrkyW9sFUqdO8z18G0IpohMLKRsAiSBKOoVc-i8LukQfoACefw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Feb 2022 09:46:36 -0500 (EST)
Message-ID: <e781d772-71a8-f073-66cf-0b415399413e@flygoat.com>
Date:   Tue, 8 Feb 2022 14:46:36 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH for-5.4,5.10] kbuild: simplify access to the kernel's
 version
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
References: <20220207143643.234233-1-jiaxun.yang@flygoat.com>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
In-Reply-To: <20220207143643.234233-1-jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Oh Please ignore this series of backport.

We find another way to workaround the issue.

Sorry for the noice :-(

Thanks.
- Jiaxun

在 2022/2/7 14:36, Jiaxun Yang 写道:
> From: Sasha Levin <sashal@kernel.org>
>
> commit 88a686728b3739d3598851e729c0e81f194e5c53 upstream.
>
> Instead of storing the version in a single integer and having various
> kernel (and userspace) code how it's constructed, export individual
> (major, patchlevel, sublevel) components and simplify kernel code that
> uses it.
>
> This should also make it easier on userspace.
>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> [jiaxun.yang@flygoat.com: Stable backport, fix geth as well.]
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
>   Makefile                                       | 5 ++++-
>   drivers/net/ethernet/mellanox/mlx5/core/main.c | 4 ++--
>   drivers/scsi/gdth.c                            | 6 +++---
>   drivers/usb/core/hcd.c                         | 4 ++--
>   include/linux/usb/composite.h                  | 4 ++--
>   kernel/sys.c                                   | 2 +-
>   6 files changed, 14 insertions(+), 11 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index 324939b64d7b..92dd066edd44 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1183,7 +1183,10 @@ define filechk_version.h
>   		expr $(VERSION) \* 65536 + $(PATCHLEVEL) \* 256 + $(SUBLEVEL)); \
>   	fi;                                                              \
>   	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) +  \
> -	((c) > 255 ? 255 : (c)))'
> +	((c) > 255 ? 255 : (c)))';                                       \
> +	echo \#define LINUX_VERSION_MAJOR $(VERSION);                    \
> +	echo \#define LINUX_VERSION_PATCHLEVEL $(PATCHLEVEL);            \
> +	echo \#define LINUX_VERSION_SUBLEVEL $(SUBLEVEL)
>   endef
>   
>   $(version_h): PATCHLEVEL := $(if $(PATCHLEVEL), $(PATCHLEVEL), 0)
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> index f2657cd3ffa4..d57d0bc8d933 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> @@ -230,8 +230,8 @@ static void mlx5_set_driver_version(struct mlx5_core_dev *dev)
>   	remaining_size = max_t(int, 0, driver_ver_sz - strlen(string));
>   
>   	snprintf(string + strlen(string), remaining_size, "%u.%u.%u",
> -		 (u8)((LINUX_VERSION_CODE >> 16) & 0xff), (u8)((LINUX_VERSION_CODE >> 8) & 0xff),
> -		 (u16)(LINUX_VERSION_CODE & 0xffff));
> +		LINUX_VERSION_MAJOR, LINUX_VERSION_PATCHLEVEL,
> +		LINUX_VERSION_SUBLEVEL);
>   
>   	/*Send the command*/
>   	MLX5_SET(set_driver_version_in, in, opcode,
> diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
> index fe03410268e6..3ff0326f22fd 100644
> --- a/drivers/scsi/gdth.c
> +++ b/drivers/scsi/gdth.c
> @@ -3907,9 +3907,9 @@ static int gdth_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
>         {
>           gdth_ioctl_osvers osv;
>   
> -        osv.version = (u8)(LINUX_VERSION_CODE >> 16);
> -        osv.subversion = (u8)(LINUX_VERSION_CODE >> 8);
> -        osv.revision = (u16)(LINUX_VERSION_CODE & 0xff);
> +        osv.version = LINUX_VERSION_MAJOR;
> +        osv.subversion = LINUX_VERSION_PATCHLEVEL;
> +        osv.revision = LINUX_VERSION_SUBLEVEL;
>           if (copy_to_user(argp, &osv, sizeof(gdth_ioctl_osvers)))
>                   return -EFAULT;
>           break;
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> index 39203f2ce6a1..323f210090bf 100644
> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -110,8 +110,8 @@ DECLARE_WAIT_QUEUE_HEAD(usb_kill_urb_queue);
>    */
>   
>   /*-------------------------------------------------------------------------*/
> -#define KERNEL_REL	bin2bcd(((LINUX_VERSION_CODE >> 16) & 0x0ff))
> -#define KERNEL_VER	bin2bcd(((LINUX_VERSION_CODE >> 8) & 0x0ff))
> +#define KERNEL_REL	bin2bcd(LINUX_VERSION_MAJOR)
> +#define KERNEL_VER	bin2bcd(LINUX_VERSION_PATCHLEVEL)
>   
>   /* usb 3.1 root hub device descriptor */
>   static const u8 usb31_rh_dev_descriptor[18] = {
> diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
> index 2040696d75b6..764f58b74f26 100644
> --- a/include/linux/usb/composite.h
> +++ b/include/linux/usb/composite.h
> @@ -573,8 +573,8 @@ static inline u16 get_default_bcdDevice(void)
>   {
>   	u16 bcdDevice;
>   
> -	bcdDevice = bin2bcd((LINUX_VERSION_CODE >> 16 & 0xff)) << 8;
> -	bcdDevice |= bin2bcd((LINUX_VERSION_CODE >> 8 & 0xff));
> +	bcdDevice = bin2bcd(LINUX_VERSION_MAJOR) << 8;
> +	bcdDevice |= bin2bcd(LINUX_VERSION_PATCHLEVEL);
>   	return bcdDevice;
>   }
>   
> diff --git a/kernel/sys.c b/kernel/sys.c
> index b075fe84eb5a..0278461760b0 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1228,7 +1228,7 @@ static int override_release(char __user *release, size_t len)
>   				break;
>   			rest++;
>   		}
> -		v = ((LINUX_VERSION_CODE >> 8) & 0xff) + 60;
> +		v = LINUX_VERSION_PATCHLEVEL + 60;
>   		copy = clamp_t(size_t, len, 1, sizeof(buf));
>   		copy = scnprintf(buf, copy, "2.6.%u%s", v, rest);
>   		ret = copy_to_user(release, buf, copy + 1);

