Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7C967FA17
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 18:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjA1RvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Jan 2023 12:51:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbjA1RvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Jan 2023 12:51:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366C8222E2
        for <stable@vger.kernel.org>; Sat, 28 Jan 2023 09:51:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9452660BB5
        for <stable@vger.kernel.org>; Sat, 28 Jan 2023 17:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927A0C433EF;
        Sat, 28 Jan 2023 17:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674928272;
        bh=pm5BQzLuamzV2NyRq5J6gigouQmXGBehlLO/cOO/iQk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f6XbD3ih1aKLJG2pUh2Zb4qOdabiRlpNiljSCyDMWF+m0IUD2f4WibHfyBSrcnGO1
         S2qb1l64oNSKDusmhvfbtdEx3uDnFbbxH4AKbyQE6oTOynkADuO9H09k6EsKnpXQhj
         r1jIEx1Hc6GGpcE7frcADCeyuj4Y1xd5f1jDyqY0=
Date:   Sat, 28 Jan 2023 18:51:08 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Computer Enthusiastic <computer.enthusiastic@gmail.com>
Cc:     stable@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        Salvatore Bonaccorso <carnil@debian.org>,
        Lyude Paul <lyude@redhat.com>
Subject: Re: [Nouveau] [PATCH] nouveau: explicitly wait on the fence in
 nouveau_bo_move_m2mf
Message-ID: <Y9VgjLneuqkl+Y87@kroah.com>
References: <20220819200928.401416-1-kherbst@redhat.com>
 <CAHSpYy0HAifr4f+z64h+xFUmMNbB4hCR1r2Z==TsB4WaHatQqg@mail.gmail.com>
 <CACO55tv0jO2TmuWcwFiAUQB-__DZVwhv7WNN9MfgMXV053gknw@mail.gmail.com>
 <CAHSpYy117N0A1QJKVNmFNii3iL9mU71_RusiUo5ZAMcJZciM-g@mail.gmail.com>
 <cdfc26b5-c045-5f93-b553-942618f0983a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdfc26b5-c045-5f93-b553-942618f0983a@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 28, 2023 at 03:49:59PM +0100, Computer Enthusiastic wrote:
> Hello,
> 
> The patch "[Nouveau] [PATCH] nouveau: explicitly wait on the fence in
> nouveau_bo_move_m2mf" [1] was marked for kernels v5.15+ and it was merged
> upstream.
> 
> The same patch [1] works with kernel 5.10.y, but it is not been merged
> upstream so far.
> 
> According to Karol Herbst suggestion [2], I'm sending this message to ask
> for merging it into 5.10 kernel.

We need to know the git commit id.  And have you tested it on 5.10.y?
And why are you stuck on 5.10.y for this type of hardware?  Why not move
to 5.15.y or 6.1.y?

And as my bot says:

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>

thanks,

greg k-h
