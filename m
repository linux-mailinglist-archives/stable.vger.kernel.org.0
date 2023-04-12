Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5AD6DF8E8
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 16:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjDLOup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 10:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbjDLOuo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 10:50:44 -0400
Received: from mail.antaris-organics.com (mail.antaris-organics.com [91.227.220.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097C16A71;
        Wed, 12 Apr 2023 07:50:40 -0700 (PDT)
Date:   Wed, 12 Apr 2023 16:50:38 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mareichelt.com;
        s=202107; t=1681311039;
        bh=avSKf7aMwZF7G9TDqOf0hROwIlS+0n7ngWulIW1NFBo=;
        h=Date:From:To:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To:Cc:Cc:content-type:content-type:date:date:
         From:from:in-reply-to:in-reply-to:message-id:mime-version:
         references:reply-to:Sender:Subject:Subject:To:To;
        b=L5ywQ4V2F4t05SbxxVO04uzQ5D5NysqFfQLDgydosa6h+bFN9+4aobKOMcX7lz1R7
         ajlgW4qrFrobGW5G4gcjOlInyxRHrL4gHhacoMYZV5kn88uXm2yQAX+ktXZ56DvaWK
         Gw3wWgxc/I3b8jMtn3KZJSkkinWYWBKjpkofrpIZw/V+aIlpeInYSw0xGsd6/uLHfx
         OfMbBWKqzhVY/AGWUCcPTl3YjteEXceliELjMdTvcR9JwhHxkmjxQv0MPntNKU4gRx
         rwJL+rBdm7kpsANsXGol7nkJ6Z9TnEZtq4kSg2TuXlw+UmSL8sjOJBoY3YY31THca1
         DcMjqdF69VTgw==
From:   Markus Reichelt <lkt+2023@mareichelt.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.2 000/173] 6.2.11-rc1 review
Message-ID: <20230412145038.GA3871@pc21.mareichelt.com>
Mail-Followup-To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230412082838.125271466@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
Organization: still stuck in reorganization mode
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.2.11 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 Apr 2023 08:28:02 +0000.
> Anything received after that time might be too late.

Hi Greg

6.2.11-rc1

compiles, boots and runs here on x86_64
(AMD Ryzen 5 PRO 4650G, Slackware64-15.0)

Tested-by: Markus Reichelt <lkt+2023@mareichelt.com>
