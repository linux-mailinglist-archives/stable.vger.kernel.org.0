Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB866174C5
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 04:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiKCDK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 23:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbiKCDKV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 23:10:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8AF1402B
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 20:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA702B825F3
        for <stable@vger.kernel.org>; Thu,  3 Nov 2022 03:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B46C433D7;
        Thu,  3 Nov 2022 03:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667445017;
        bh=sh0qgJV2EeSYTR8za6yajqWY6JtD++tYejJcGW4RzWE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ztq45dkYq6r8kUP05HDEyvLucCN+4vhPC+8QqSpsHDGQMD+QGkPpPRNWVbuGJ+ZjD
         IMdiPwn0vwC7l4j1PqHd17Vyx0F7DnmoMGs/VRdsKlayZ9p5Fh/a0Z1z7cdq9ytVtz
         KZK+5540tmV3h/g/ZyckitNqS8VJcrpI4wEFEVJs=
Date:   Thu, 3 Nov 2022 04:11:13 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Anil Altinay <aaltinay@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: Backporting 7a62ed61367b8fd01bae1e18e30602c25060d824 to 5.15
 stable
Message-ID: <Y2MxURlV6NRjSABO@kroah.com>
References: <CACCxZWP-O07hx0QpZNkuG9xPH-QG71t-1e5qZU8hNkkyvFKVhA@mail.gmail.com>
 <Y2F0s/+TDf7deuIg@kroah.com>
 <CACCxZWPVXAR2tdf7twp=OtOico=EhaXjVQY=yxdxhMgJutuEfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACCxZWPVXAR2tdf7twp=OtOico=EhaXjVQY=yxdxhMgJutuEfw@mail.gmail.com>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 02, 2022 at 07:59:24PM -0700, Anil Altinay wrote:
> Please see attached patch for backported version with the commit
> message updated with the upstream commit SHA. I also applied this
> patch to our kernel and it built fine. Hopefully, it is good to go
> this time.

You forgot to sign off on the patch :(

