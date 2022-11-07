Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25EEF61EDF2
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 09:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbiKGI5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 03:57:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbiKGI5u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 03:57:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0529415FFA
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 00:57:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9207A60F5B
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 08:57:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A599C433C1;
        Mon,  7 Nov 2022 08:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667811466;
        bh=Dai4uYb7GfZJE4OW4tbfIlmz3t0qc1zImLZ2aWP6o/g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ioH0d27v1OnOLVy9lfEvzzv76Pq2n97hAHTr+K/e/LuYZPOejZWZqH3tPabmpEPcw
         mTVhTEqAoCRrU1P3kU3MnfV5b4uV36YUf1IxHm1YaGvlFq3AEIsXEipJXnVdFJ+Vz8
         asf2F4rT/ExFxwa116bm6HsXT5FPepwHhftrwiSI=
Date:   Mon, 7 Nov 2022 09:57:43 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Anil Altinay <aaltinay@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: Backporting 7a62ed61367b8fd01bae1e18e30602c25060d824 to 5.15
 stable
Message-ID: <Y2jIh1EB1l+b8hQT@kroah.com>
References: <CACCxZWP-O07hx0QpZNkuG9xPH-QG71t-1e5qZU8hNkkyvFKVhA@mail.gmail.com>
 <Y2F0s/+TDf7deuIg@kroah.com>
 <CACCxZWPVXAR2tdf7twp=OtOico=EhaXjVQY=yxdxhMgJutuEfw@mail.gmail.com>
 <Y2MxURlV6NRjSABO@kroah.com>
 <CACCxZWM6kBhEeaMSBO05e2UzBWWVTU8Cd_-nw1w-pk=JSLzivQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACCxZWM6kBhEeaMSBO05e2UzBWWVTU8Cd_-nw1w-pk=JSLzivQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 02, 2022 at 11:44:49PM -0700, Anil Altinay wrote:
> Ops, I am sorry. It is my first time sending a patch to the stable
> tree. I added "Signed-off-by: Anil Altinay <aaltinay@google.com>" at
> the end of the Signed-off list. Hopefully, it is good to go this time
> :) Thanks for your patience Greg!

Now queued up, thanks.

greg k-h
