Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB59535143
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 17:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbiEZPNk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 11:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242262AbiEZPNj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 11:13:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18CE3FD9E
        for <stable@vger.kernel.org>; Thu, 26 May 2022 08:13:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27DC761C2E
        for <stable@vger.kernel.org>; Thu, 26 May 2022 15:13:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46D2C385A9;
        Thu, 26 May 2022 15:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653578016;
        bh=toWXNXD0p8YV+UzD4BlBkib4/xFf1x8f7O7j5Ma9xfk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zuWIX+rnL3I3qJgptl+dv5UyuIVRcUF1dSa8kdCbxotBGpGEYFE+w6d4FQuE1ff4n
         yqPwY/DPQkXccHBEkxLpmxfPayPo4EOOeUO4SYDwwJQfnlaSTJSYkGwJal0PsNpaaY
         TWZl/5lGpNGg8cUxduW5mGIQzt7Hhxk4Z8J1wJIc=
Date:   Thu, 26 May 2022 17:13:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     dann frazier <dann.frazier@canonical.com>
Cc:     stable@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Aristeu Rozanski <aris@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: Avoid Oops reading ACPI BERT table in sysfs on ARM systems
Message-ID: <Yo+ZHf3QfllpUmB9@kroah.com>
References: <Yo+VWA+zaTGIcvrL@xps13.dannf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo+VWA+zaTGIcvrL@xps13.dannf>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 26, 2022 at 08:57:28AM -0600, dann frazier wrote:
> hey Greg,
> 
>   I'm proposing the following commits for stable, as they fix an
> oops we're seeing in our testing[*]:
> 
> This is needed to 4.14.y -> 5.18.y:
> 1bbc21785b73 ACPI: sysfs: Fix BERT error region memory mapping
> 
> A dependency of the above, needed for 4.14.y -> 5.10.y
> bdd56d7d8931 ACPI: sysfs: Make sparse happy about address space in use
> 
>   -dann
> 
> [*] https://launchpad.net/bugs/1973153

Now queued up, thanks.

greg k-h
