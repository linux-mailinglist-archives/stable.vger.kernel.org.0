Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F2D6A6744
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 06:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjCAFOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 00:14:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjCAFOA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 00:14:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7281498A;
        Tue, 28 Feb 2023 21:13:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CCC461239;
        Wed,  1 Mar 2023 05:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4077CC433D2;
        Wed,  1 Mar 2023 05:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677647638;
        bh=xqMXX32qTAB/NfSdpjy08/YWnh0B4I4J/SXxYK7EmLI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iaBaqnXeIb9wS4vLfx4bAEo6wp0NEQyXfxsotUNUsjF5yQhWC01y166bhw1Unb0/E
         eZtxXMwCHPfBkxf8cz+YIuwNuwqnhvqnMrrSmBgPTBIiUrJolSfy5Zzy0LBswc9QGG
         1OWyUewcRmg2R0Q3UbN0gockaP4EyzWlWPqRZxULP90ObF0biHQ/53p0Asp8WY/hSj
         Dz+vo3EDtStwX9+dtF0mbwagqHyAPekn82/wCnpKlKSsU0UVPnZXIQ4LAJIaMRgjhy
         zCepyQ83qA8gIuV9d9OnHLKiWqNyG7SrPuNz5wMoMT2rqD+KKpPlGnYt6rEk2p11a6
         U99TlI9mmj7Gw==
Date:   Tue, 28 Feb 2023 21:13:56 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Slade Watkins <srw@sladewatkins.net>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <Y/7fFHv3dU6osd6x@sol.localdomain>
References: <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <Y/0U8tpNkgePu00M@sashalap>
 <Y/0i5pGYjrVw59Kk@gmail.com>
 <Y/0wMiOwoeLcFefc@sashalap>
 <Y/1LlA5WogOAPBNv@gmail.com>
 <Y/1em4ygHgSjIYau@sashalap>
 <Y/136zpJSWx96YEe@sol.localdomain>
 <CAOQ4uxietbePiWgw8aOZiZ+YT=5vYVdPH=ChnBkU_KCaHGv+1w@mail.gmail.com>
 <Y/3lV0P9h+FxmjyF@kroah.com>
 <8caf1c23-54e7-6357-29b0-4f7ddf8f16d2@sladewatkins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8caf1c23-54e7-6357-29b0-4f7ddf8f16d2@sladewatkins.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 28, 2023 at 09:05:16PM -0500, Slade Watkins wrote:
> On 2/28/23 06:28, Greg KH wrote:
> >> But just so you know, as a maintainer, you have the option to request that
> >> patches to your subsystem will not be selected by AUTOSEL and run your
> >> own process to select, test and submit fixes to stable trees.
> > 
> > Yes, and simply put, that's the answer for any subsystem or maintainer
> > that does not want their patches picked using the AUTOSEL tool.
> > 
> > The problem that the AUTOSEL tool is solving is real, we have whole
> > major subsystems where no patches are ever marked as "for stable" and so
> > real bugfixes are never backported properly.
> 
> Yeah, I agree.
> 
> And I'm throwing this out here [after having time to think about it due to an
> internet outage], but, would Cc'ing the patch's relevant subsystems on AUTOSEL
> emails help? This was sort of mentioned in this email[1] from Eric, and I
> think it _could_ help? I don't know, just something that crossed my mind earlier.
> 

AFAICT, that's already being done now, which is good.  What I was talking about
is that the subsystem lists aren't included on the *other* stable emails.  Most
importantly, the "FAILED: patch failed to apply to stable tree" emails.

- Eric
