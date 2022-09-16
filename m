Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB165BAC11
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 13:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiIPLLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 07:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbiIPLKx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 07:10:53 -0400
X-Greylist: delayed 1250 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 16 Sep 2022 04:08:24 PDT
Received: from gateway20.websitewelcome.com (gateway20.websitewelcome.com [192.185.4.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324A351420
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 04:08:24 -0700 (PDT)
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id D7C44400CF48F
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 05:47:31 -0500 (CDT)
Received: from 162-215-252-169.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id Z8scoGarY3RgQZ8sdoaROA; Fri, 16 Sep 2022 05:47:31 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=68lndCO94kjSsn/PzI7fA4q5CQxHtuDW4XWGX7RfISU=; b=rzX2gafI1PoIzsluF/JFARGwPu
        59S5pGlGO4Bmz8+fP9ahkcDK3D4rhCfLCIpZsIlGC0Bk9GlaEM3/HBPsSXRrDTzOUyAwEml+lVx2t
        woR+HNCku8e8SJnyincMfqa8mrEQAk59t+WU0nTrPb0QGq8EvwKsGIkg6FIABKGag8jk8UwwEnobR
        G3r2lA4lSywP+bwpkaD9aw+T3lW1TvKr2u1cZ00HzxXMAPu5UBIbO2gq4Pky30WtI1D53kpgc5bf4
        7xZ5tK0MUQV9ieaW72FKe+n9XphtWLulxpTDn9stdUDtfe2L2vvbdGHw1ZqP8EXcJvGLPOEGOz8jy
        jZp4oleg==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:58840 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <linux@roeck-us.net>)
        id 1oZ8sc-000owT-FV;
        Fri, 16 Sep 2022 10:47:30 +0000
Date:   Fri, 16 Sep 2022 03:47:25 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Sasha Levin <sashal@kernel.org>, stable-commits@vger.kernel.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jean Delvare <jdelvare@suse.com>
Subject: Re: Patch "hwmon: (pmbus) Use dev_err_probe() to filter
 -EPROBE_DEFER error messages" has been added to the 5.10-stable tree
Message-ID: <20220916104725.GB4060280@roeck-us.net>
References: <20220915124557.591485-1-sashal@kernel.org>
 <92e8f14b-04f4-88a1-6071-fc87117ba5a1@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <92e8f14b-04f4-88a1-6071-fc87117ba5a1@wanadoo.fr>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1oZ8sc-000owT-FV
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:58840
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 7
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_SOFTFAIL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 15, 2022 at 08:48:05PM +0200, Marion & Christophe JAILLET wrote:
> 
> Le 15/09/2022 à 14:45, Sasha Levin a écrit :
> > This is a note to let you know that I've just added the patch titled
> > 
> >      hwmon: (pmbus) Use dev_err_probe() to filter -EPROBE_DEFER error messages
> > 
> > to the 5.10-stable tree which can be found at:
> >      http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >       hwmon-pmbus-use-dev_err_probe-to-filter-eprobe_defer.patch
> > and it can be found in the queue-5.10 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> > 
> Hi,
> 
> I'm not sure that this one makes a real sense for backport.
> 
> It can't hurt, but it does not fix a real issue, it just voids a potential
> spurious message.
> 
> In my original mail, there is no "stable@" or "fix" or "bug" keywords or
> "Fixes:" tag.
> There is also apparently no patch in this backport serie that relies on this
> patch.
> 
> Why has it been selected?
> 
That is essentially how AUTOSEL works. It picks patches based on keywords.
I am sure Sasha can provide details.

Guenter
