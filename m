Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B70660C56B
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 09:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbiJYHhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 03:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbiJYHhJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 03:37:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5388A1C129
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 00:37:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4C41617B5
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 07:37:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B82C433C1;
        Tue, 25 Oct 2022 07:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666683427;
        bh=hYJG/BPRkJtvHH928JSLX1Fi+/NSEAgauro6SGlkeFo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2MpW4bYtSNRDJXX3LxJ9ibHvVbcUAYWBUjNrxl/uK89egmJ19lE4tmSKeyaTBD63T
         25bYC6Aaa322+Lg/MAo25NehJGDBRar5Yc+1MW6zYpZE1fuAEwUqom5JTm17ADdxt7
         QGc/bIxjxP1n5yMZdQ0jcaS5FNxcFPxufXo2EyGM=
Date:   Tue, 25 Oct 2022 09:37:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tobias Powalowski <tobias.powalowski@googlemail.com>
Cc:     stable@vger.kernel.org
Subject: Re: Fwd: 6.0.3 broke space_cache=v1 devices
Message-ID: <Y1eSV5IpNnIiAQ8K@kroah.com>
References: <CAHfPjO-gtcdvzgjm1o5NdS0bRy8ukyROH24UhWUATn6ouj07yw@mail.gmail.com>
 <CAHfPjO8G1Tq2iJDhPry-dPj1vQZRh4NYuRmhHByHgu7_2rQkrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHfPjO8G1Tq2iJDhPry-dPj1vQZRh4NYuRmhHByHgu7_2rQkrQ@mail.gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 24, 2022 at 09:17:08PM +0200, Tobias Powalowski wrote:
> Hi,
> https://bugs.archlinux.org/task/76266
> as talked to darkling on btrfs IRC here the report for the to stable ML too.
> My servers got broken with kernel 6.0.3, downgrading to 6.0.2 solved my issue.
> 
> My btrfs was using version 1 of space_cache, after upgrading it to version 2
> 6.0.3 worked.

See the thread here:
	https://lore.kernel.org/r/Y1aeWdHd4/luzhAu@localhost.localdomain

I'll work to resolve this in 6.0.4.

thanks,

greg k-h
