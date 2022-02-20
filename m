Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE454BCE2D
	for <lists+stable@lfdr.de>; Sun, 20 Feb 2022 12:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbiBTLfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Feb 2022 06:35:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbiBTLfT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Feb 2022 06:35:19 -0500
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543A431DDE
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 03:34:58 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 8A7753201ECF;
        Sun, 20 Feb 2022 06:34:55 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 20 Feb 2022 06:34:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=/L+o0ClPkVfN7wyHU2C/xDMISu5MaNKpiSweDv
        gJOwQ=; b=GwPPSxqfDBTRnAwS7IvbcNVIIxIIEK6S8JVmJt+WytoC9Zy3ZH9c0V
        v0R5/bTlQV1uBMXzrTEWcTRoxDsNb2X8Duo4e6Dk3fWNA2KA5jbS74iytHcksjm9
        ykFqUPLmDmKyQZ1LSVvEJURmpzIUDpinI+iyNREbijQwuWnm1rdH3gLZuC0YP6UD
        V8Nk6AWJwMyWbtLflBVVEI9+JDy9uRQLnMo64mlCF8y7swdULNBsEce6dhLSEH9p
        6TzqzBBSt6sbEp4jA9XBGWkHMvt9zCoe0AWXFJQj1YW7mJAh1FbATubHjmBRyo31
        aNoWqbQVSEartLXLxeR66ll2S9tf5jNg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/L+o0ClPkVfN7wyHU
        2C/xDMISu5MaNKpiSweDvgJOwQ=; b=IoHnXBIejth0GtZEoLiAagv2vUQCxsmBL
        J5/k3kO6zDi6T0ZZ/m2fHrv9Y3b6PqCJ2WzLvdPl7DM/2chCbYs4LETJeyobWfvf
        Dr+UyNCr6RZWnGt/y7SfCJOKGQyTIUoEdaM+ciTyLwNFil/qAAMZ8qSznk2j+/al
        mgWIILrPLohRSSWNd0VpggHkzNdQ5x4q2ZA6Gh858hqIedayTStvxcLJofBs94vj
        5MPvMHC1XoJpZr1igTCqXamh48qwT3jpyGD/Yyl7Ut097M2TJLtHzMMFu4aFMiub
        DlWhORGryaWwUE7ZS5liB6giwo9kvnNYNHyYX77zKQkbu4c5fNeAg==
X-ME-Sender: <xms:XicSYgfXy3tdSAF0dEI2zh7R4Xyxm_oCPOnStr59m8jjN72saHKhsQ>
    <xme:XicSYiP0ZG3fHZm2wLvdf_h73VlQBg3GiwBqCBl_ufbHWzqVZmdYHOBCGiffIY9fv
    MUS0K0PPoLJnQ>
X-ME-Received: <xmr:XicSYhi996g_0FljU52OgB6YbjubhUjEWKhU0ziLUTj2TKErEeA2h_XYv56qc_fyy6KfiAMmn1RnHhAQVFgA7WvraOxPVS6Z>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrkeeggdeftdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:XicSYl9_YuxkaVcvc-eHydkv5OD8txhPV4LDsNl_cF4K8WRq3uiflA>
    <xmx:XicSYstZNy5fgg2Edw8y7KsZMXInh4zLoZpayc_cIbSOWkkuHMNuyA>
    <xmx:XicSYsE5SLpP3TIZS9Hk9YVcyCmWVpno5OFbNeXUlv8FHXhk-MGCyA>
    <xmx:XycSYggMCcGoSuYpL3LI5ilAy6u7gSKaEy0FsVOyYjHHLFGJHuA4GQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 20 Feb 2022 06:34:54 -0500 (EST)
Date:   Sun, 20 Feb 2022 12:34:51 +0100
From:   Greg KH <greg@kroah.com>
To:     Jens Wiklander <jens.wiklander@linaro.org>
Cc:     stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Lars Persson <larper@axis.com>
Subject: Re: [PATCH backport 5.4] optee: use driver internal tee_context for
 some rpc
Message-ID: <YhInW24hysjk1Pex@kroah.com>
References: <20220218163910.858812-1-jens.wiklander@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218163910.858812-1-jens.wiklander@linaro.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 18, 2022 at 05:39:10PM +0100, Jens Wiklander wrote:
> commit aceeafefff736057e8f93f19bbfbef26abd94604 upstream
> 
> Adds a driver private tee_context to struct optee.
> 
> The new driver internal tee_context is used when allocating driver
> private shared memory. This decouples the shared memory object from its
> original tee_context. This is needed when the life time of such a memory
> allocation outlives the client tee_context.
> 
> This fixes a problem where the tee_context allocated on behalf of a
> process outlives the process because some longer lived driver internal
> shared memory has been allocated using that tee_context.
> 
> Fixes: 217e0250cccb ("tee: use reference counting for tee_context")
> Reported-by: Lars Persson <larper@axis.com>
> Cc: stable@vger.kernel.org # 1e2c3ef0496e tee: export teedev_open() and teedev_close_context()
> Cc: stable@vger.kernel.org
> Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
> [JW: backport to 5.4-stable + update commit message]
> Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
> ---
> 
> Hi,
> 
> Please note that this patch depends on 1e2c3ef0496e ("tee: export
> teedev_open() and teedev_close_context()") which needs be cherry-picked
> before this patch is applied.
> 
> This differs from the previous backports (5.16, 5.15, 5.10) in the way that
> f25889f93184 ("optee: fix tee out of memory failure seen during kexec
> reboot") isn't in this branch. So we can't claim to fix that problem, but
> this patch still makes sense since the lifetime problem can manifest itself
> in other ways too.

Now queued up, thanks.

greg k-h
