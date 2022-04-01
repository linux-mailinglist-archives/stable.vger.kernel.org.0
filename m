Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B92634EF598
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243158AbiDAPPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354649AbiDAPMO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 11:12:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5D02AFA0A;
        Fri,  1 Apr 2022 07:55:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FD89B824FC;
        Fri,  1 Apr 2022 14:55:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF63C2BBE4;
        Fri,  1 Apr 2022 14:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648824930;
        bh=XCmTIOXK1YIHSJwxCWXOIB9CkJ+9xoNLRuagr76eCMk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FoSt0Ah8YdHJpPRyLvrPAhj06RFciymYJmGAJokHpi78ihCu03TNQpUP2zJT/F98S
         RzfYleFTdNj25DLbaye1kQS5D5OWg9REvqOlgUeTERgOXGzhLBuotyL0PchqnZFH1n
         /vv+qLfQ3JCsZCmlhbfEydN0HJsMXdAUJtLD4ggM=
Date:   Fri, 1 Apr 2022 16:55:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dan Vacura <w36195@motorola.com>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Carlos Bilbao <bilbao@vt.edu>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: uvc: allow changing interface name via
 configfs
Message-ID: <YkcSX5P2KKj9qnWe@kroah.com>
References: <20220331211155.412906-1-w36195@motorola.com>
 <YkaZcSsadjHp1yJZ@kroah.com>
 <YkcQmrm30D7cNPDo@p1g3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkcQmrm30D7cNPDo@p1g3>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 01, 2022 at 09:47:54AM -0500, Dan Vacura wrote:
> On Fri, Apr 01, 2022 at 08:19:29AM +0200, Greg Kroah-Hartman wrote:
> > On Thu, Mar 31, 2022 at 04:11:50PM -0500, Dan Vacura wrote:
> > > Add a configfs entry, "function_name", to change the iInterface field
> > > for VideoControl. This name is used on host devices for user selection,
> > > useful when multiple cameras are present. The default will remain "UVC
> > > Camera".
> > > 
> > > Cc: <stable@vger.kernel.org> # 5.10+
> > 
> > Why is adding a new feature a stable kernel issue?
> > 
> > confused,
> > 
> > greg k-h
> 
> The intention is to get this change integrated into the Android GKI 5.10
> and 5.15 release lines.

Android and "GKI" has nothing to do with the stable kernel trees or us
at all.

Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for what patches are acceptable to them.

thanks,

greg k-h
