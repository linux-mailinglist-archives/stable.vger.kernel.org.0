Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F29B94CE507
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 14:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbiCENlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 08:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiCENlB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 08:41:01 -0500
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAAB7805D
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 05:40:11 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id CEAAE3200EAD;
        Sat,  5 Mar 2022 08:40:10 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sat, 05 Mar 2022 08:40:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=IHBTuKTGhY1dMpfuTOo74ZQTj1brJqnxPGFsgF
        VZF4g=; b=cRcC82a8sZKeTJ0I9LUqm/6/lTFN7dZ/D5WffFjEVTRUT4pYPZW1pQ
        Y6ouI3d4ya1l3x8UcxK/Le9Hwc6LifYsXDPZMiPtO/xwACj+ObICNSPP8aWskkRd
        Q7k2185SOQF8DdZfkDIUNTZQcCt0h/FrFV/vB9SNt7iX13bkY7ELzLZj+c4ItV4r
        vzZ+LbPxBS1yrmUjhgyQvgesoE+fSSm0UwqMfthWk+/xx2X7l3rbPTtPLEoF+9eg
        QjtJxKJ9mT8mwKuheW+PLBTBANiPa4kjI88sQWlPjEGk5ROx8EYVstHlZBeTsVLM
        wFHQbeUsrCO+XX5z9BMxt6GtrWc/aYhQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=IHBTuKTGhY1dMpfuT
        Oo74ZQTj1brJqnxPGFsgFVZF4g=; b=hVe7L0VO3zgIVu6m/SMFrOM5Syp9cYbtU
        qTJbpcC7ep5cyHI1uHrKvdzUyoKD9Y9Mgpk+4IMyNGylMYu6rXi5T/Wp6tEsbYWP
        pUOES4CSb9cdwWypEweZG39tBB+OkKJqqGu0YP2sN57Z+p3NoIjoQTHpU/YkcV10
        HsO+lsalmHVSjjmiInA9A5bsLo6vSQ9KFHZDuuAhSqHypJ9R4a9hWxw2sdGcnlmz
        QL/VD3FT86g5wi/6oj8lAz3vy2Hx7VZrw2khC/cyG8lMpIaF/IdNlTOjvRbsdz4c
        wxFMRr7turzVLpehiWJhMZ+xp5GNDbY7jjDXjVATnVzLooD3B70Ig==
X-ME-Sender: <xms:OmgjYkFE4DGP-gNjPoCOIv_YtcAOalSyEvhUjDLRZfIc-rYkGYfSeA>
    <xme:OmgjYtWRsUswJN4noSGGAtzRyjuB3jINIBW7CvyFzpKITwadC3psbqcRGDohg_hd-
    yh4XqB5cWxHBw>
X-ME-Received: <xmr:OmgjYuLNXOH1bGNyxW_9-EImBlXxCpxB8hIY8g0V8dOdKL_ZE3po9xu-mcI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddutddgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:OmgjYmEhuGIWpi-v45-7n0kThj1PP9PBI-_Z5h8KsObEdNpabQBzEQ>
    <xmx:OmgjYqUgE5bby6SWXYOWLKQLpslegyODKH5XDpBVqCfSPwzG1s_IBQ>
    <xmx:OmgjYpPAe8S6JNnRKi7nVkhNYVc8VXWtHXX0w6WXigOoiyquc_WLBg>
    <xmx:OmgjYni9YSlVQlr7G3N3-zT8R6yRm6AiSIQALv10dPxhNKhPtr-8Aw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 5 Mar 2022 08:40:09 -0500 (EST)
Date:   Sat, 5 Mar 2022 14:40:07 +0100
From:   Greg KH <greg@kroah.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/2] ice: Fix race conditions between virtchnl handling
 and VF ndo ops
Message-ID: <YiNoN+pvklPaIMT4@kroah.com>
References: <20220228204700.3260650-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228204700.3260650-1-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 28, 2022 at 12:46:59PM -0800, Jacob Keller wrote:
> From: Brett Creeley <brett.creeley@intel.com>
> 
> commit e6ba5273d4ede03d075d7a116b8edad1f6115f4d upstream.
> 
> [I had to fix the cherry-pick manually as the patch added a line around
> some context that was missing.]
> 
> The VF can be configured via the PF's ndo ops at the same time the PF is
> receiving/handling virtchnl messages. This has many issues, with
> one of them being the ndo op could be actively resetting a VF (i.e.
> resetting it to the default state and deleting/re-adding the VF's VSI)
> while a virtchnl message is being handled. The following error was seen
> because a VF ndo op was used to change a VF's trust setting while the
> VIRTCHNL_OP_CONFIG_VSI_QUEUES was ongoing:
> 
> [35274.192484] ice 0000:88:00.0: Failed to set LAN Tx queue context, error: ICE_ERR_PARAM
> [35274.193074] ice 0000:88:00.0: VF 0 failed opcode 6, retval: -5
> [35274.193640] iavf 0000:88:01.0: PF returned error -5 (IAVF_ERR_PARAM) to our request 6
> 
> Fix this by making sure the virtchnl handling and VF ndo ops that
> trigger VF resets cannot run concurrently. This is done by adding a
> struct mutex cfg_lock to each VF structure. For VF ndo ops, the mutex
> will be locked around the critical operations and VFR. Since the ndo ops
> will trigger a VFR, the virtchnl thread will use mutex_trylock(). This
> is done because if any other thread (i.e. VF ndo op) has the mutex, then
> that means the current VF message being handled is no longer valid, so
> just ignore it.
> 
> This issue can be seen using the following commands:
> 
> for i in {0..50}; do
>         rmmod ice
>         modprobe ice
> 
>         sleep 1
> 
>         echo 1 > /sys/class/net/ens785f0/device/sriov_numvfs
>         echo 1 > /sys/class/net/ens785f1/device/sriov_numvfs
> 
>         ip link set ens785f1 vf 0 trust on
>         ip link set ens785f0 vf 0 trust on
> 
>         sleep 2
> 
>         echo 0 > /sys/class/net/ens785f0/device/sriov_numvfs
>         echo 0 > /sys/class/net/ens785f1/device/sriov_numvfs
>         sleep 1
>         echo 1 > /sys/class/net/ens785f0/device/sriov_numvfs
>         echo 1 > /sys/class/net/ens785f1/device/sriov_numvfs
> 
>         ip link set ens785f1 vf 0 trust on
>         ip link set ens785f0 vf 0 trust on
> done
> 
> Fixes: 7c710869d64e ("ice: Add handlers for VF netdevice operations")
> Cc: <stable@vger.kernel.org> # 5.14.x
> Signed-off-by: Brett Creeley <brett.creeley@intel.com>
> Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> ---
> This should apply to 5.14.x

5.14 is long end-of-life, always look at the kernel.org page if you are
curious what the "active" kernel trees are.

thanks,

greg k-h
