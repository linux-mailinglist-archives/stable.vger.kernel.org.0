Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF995F499E
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 21:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbiJDTOZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 15:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJDTOY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 15:14:24 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A759341987;
        Tue,  4 Oct 2022 12:14:23 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id g27so3280912edf.11;
        Tue, 04 Oct 2022 12:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=samvLyre3GudL8Bc92DNFizD8+4wnf9VuThS8JRTc4I=;
        b=eEpXdwbR5DBw9V0Kc+dn/Y8OHcPL3mZxlYs9gkSyuAMhpRb/uozgAsIePfZLcnV2tw
         8pftDrv/jioLU/TtQdeeOuiNJHK0b1RVbEIzI0jiWg6juc7JivcIZOE2cwXS0iiALIYh
         lynjXnn+HU2leiBQKcvFvOESjcgSjMD6OZiCG5Z8WvtYpZr8TDU16kO6+V+ggWMoPTAu
         1x9MATFb9eQR1zygcHFjrnsWYn4/QyZtMt3Py4KSx1bKMrsg6M0wDo0fcMUs2v0YJaiZ
         /0OctUIUOFbiNOBKsW5D2yYZ5khHLH8OKSlNxi9+QrEZl6oDCjbCOaLH0Y0dJ0p4aaqQ
         0ARQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=samvLyre3GudL8Bc92DNFizD8+4wnf9VuThS8JRTc4I=;
        b=WaHcUwUgdgBIHkFihjTdD8ZGxEB8gY6d55e196szcig+h8tOGvgJqbPDiSXNK1ejMD
         nDtfgWfTkulBcvy3HL8Rniv9MAznyz90QlVPhvTis08OJMNoj9G+Y7sct4HGE2mThrKE
         qytdgFEyI6Quta8BDZE9Q9l82+eBxVoIjzmqWCMMan7rTiMWqxJERNro0Th6VSYVluo2
         LUCcl92ntvcw09GbmMbM5qwpBOPSXNYLgk7yXK5myc++Cbd0kz6MsiyoJWJQ/deYvYge
         /bEnXgIHSPgCsFBjUZHxpaSB/opUcb4CrdQ62thc5NK9GW6GK4N6VIyXsoFiPR4h2hSp
         ZI4Q==
X-Gm-Message-State: ACrzQf2gcbdm/sID97KfPj8ZycROD/+DNUG1iB9fkeE9xJyDlR42xdHd
        Bz/4DublTxX007jq8dAX9B0=
X-Google-Smtp-Source: AMsMyM60nZ0E4qugJO+vqHRRvfFkQOTzv0E/d2lH5hDyzCoCX3rTKjUmOxC64gF1ypRENrZDo2jxEQ==
X-Received: by 2002:aa7:c607:0:b0:458:fe72:4756 with SMTP id h7-20020aa7c607000000b00458fe724756mr10641174edq.423.1664910862118;
        Tue, 04 Oct 2022 12:14:22 -0700 (PDT)
Received: from ?IPV6:2a02:a466:68ed:1:9fba:fe42:f843:438d? (2a02-a466-68ed-1-9fba-fe42-f843-438d.fixed6.kpn.net. [2a02:a466:68ed:1:9fba:fe42:f843:438d])
        by smtp.gmail.com with ESMTPSA id bm15-20020a170906c04f00b0073c80d008d5sm7377851ejb.122.2022.10.04.12.14.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 12:14:21 -0700 (PDT)
Message-ID: <a7724993-6c04-92c5-3a26-3aef6d29c9e3@gmail.com>
Date:   Tue, 4 Oct 2022 21:14:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v2 2/2] Revert "usb: dwc3: Don't switch OTG -> peripheral
 if extcon is present"
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20220927155332.10762-1-andriy.shevchenko@linux.intel.com>
 <20220927155332.10762-3-andriy.shevchenko@linux.intel.com>
 <20221003215734.7l3cnb2zy57nrxkk@synopsys.com>
 <YzvusOI89ju9e5+0@smile.fi.intel.com>
Content-Language: en-US
From:   Ferry Toth <fntoth@gmail.com>
In-Reply-To: <YzvusOI89ju9e5+0@smile.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

Op 04-10-2022 om 10:28 schreef Andy Shevchenko:
> On Mon, Oct 03, 2022 at 09:57:35PM +0000, Thinh Nguyen wrote:
>> On Tue, Sep 27, 2022, Andy Shevchenko wrote:
>>> This reverts commit 0f01017191384e3962fa31520a9fd9846c3d352f.
>>>
>>> As pointed out by Ferry this breaks Dual Role support on
>>> Intel Merrifield platforms.
>> Can you provide more info than this (any debug info/description)? It
>> will be difficult to come back to fix with just this to go on. The
>> reverted patch was needed to fix a different issue.

On Merrifield we have a switch with extcon driver to switch between host 
and device mode. Now with commit 0f01017, device mode works. In host 
mode the root hub appears, but no devices appear. In the logs there are 
no messages from tusb1210, but there should be because lately there 
normally are (harmless) error messages. Nothing in the logs point in the 
direction of tusb1210 not being probed.

The discussion is here: https://lkml.org/lkml/2022/9/24/237

I tried moving some code as suggested without result: 
https://lkml.org/lkml/2022/9/24/434

And with success: https://lkml.org/lkml/2022/9/25/285

So, as Andrey Smirnov writes "I think we'd want to figure out why the 
ordering is important if we want to justify the above fix."

> It's already applied, but Ferry probably can provide more info if you describe
> step-by-step instructions. (I'm still unable to test this particular type of
> features since remove access is always in host mode.)
>
I'd be happy to test.
