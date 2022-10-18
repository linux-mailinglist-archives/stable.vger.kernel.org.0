Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77C24602098
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 03:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiJRBuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 21:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiJRBuK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 21:50:10 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A827DF72;
        Mon, 17 Oct 2022 18:50:09 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id d7-20020a17090a2a4700b0020d268b1f02so15951353pjg.1;
        Mon, 17 Oct 2022 18:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qhrY3CdotIZVTMkH6Zcw3PMbIad7eSnddTb5gX5c0Rs=;
        b=WdfEuiP0y8N6no6jKIXyX7Wa4XqSFBWD5omQ23v7APA451WzXzTZMBNcTl7ZQfstUt
         VsPKkPqnrW5RE9330oeDZbrJQem4vmCZqHuhSpDadvi6X8DmLfVq7fiVrpNvvp1pi12U
         WQ1Ig+pWSUW9s8zzk6bAOcEiP3X9JVFxKFc9LaHtjLFrsFTMwDOiUfPRV4FSZknD+CoC
         ktSUNfZy5dGvZXqNajFy+EQ2I0SSCmeVC865AZ/YuFkssAvR2Cx5RR+Tz/IsH11uV9iA
         NKBaKlUAu3HvzZDRckYZXrA2bm/JegUzTsIXast1xnzDJMQfCYMezyC5P1M4Afb1ma7b
         IUEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qhrY3CdotIZVTMkH6Zcw3PMbIad7eSnddTb5gX5c0Rs=;
        b=Iu7NOWKAJHbGO6AFErQv3/KyMfB87Y+689Yy9Ao276gMaZ98JYbUSkjdnE2cKAMeGc
         dwQ2RvTAm2J79VhJruz3oq6ya0aoW47itfeGkmU9UzTS4fRPvZEOcp3UVKFYwiEOwni9
         50qJpRlIMlodBoEIMss2D138tKEMdfEZB6kakrIISsvlJf/wbFJwtjiMlRz0TRXTM+/t
         550gUL6BVWRHnsY7Z32CM91oRbjxyplANFSTCStl2D50Vh4QRVRuWLQ5FhAJaTlrcJM+
         0Hxp7MzzEsPKzTHv88CWfie0+hhTOvhG6XzwJz/zVzyBon6onoXJMfge/64OM0NpWQhq
         ecoA==
X-Gm-Message-State: ACrzQf12pFa28FloIPNPzT2YVxfKtkl5zO4vac97kK0HOqpghD0Y43VV
        N7gKrdXOlgNkAd/OMhia1sIMEGaY/9v85w==
X-Google-Smtp-Source: AMsMyM5k6oOkMBOkEAlAtluIlFG2ihNEEjHL5qf9rqGUD0zS3Uq1mFSlHieTdtoLb1QTH/K5FPOeDQ==
X-Received: by 2002:a17:902:9a07:b0:178:8024:1393 with SMTP id v7-20020a1709029a0700b0017880241393mr578220plp.128.1666057808343;
        Mon, 17 Oct 2022 18:50:08 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-16.three.co.id. [180.214.232.16])
        by smtp.gmail.com with ESMTPSA id w29-20020aa7955d000000b0056274716016sm7835206pfq.47.2022.10.17.18.50.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 18:50:07 -0700 (PDT)
Message-ID: <f7029f41-4f8c-9ba7-3e3b-268a743998d5@gmail.com>
Date:   Tue, 18 Oct 2022 08:50:03 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH] usb: gadget: uvc: fix dropped frame after missed isoc
Content-Language: en-US
To:     Dan Vacura <w36195@motorola.com>, linux-usb@vger.kernel.org
Cc:     Daniel Scally <dan.scally@ideasonboard.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Jeff Vanhoof <qjv001@motorola.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Paul Elder <paul.elder@ideasonboard.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <20221017205446.523796-1-w36195@motorola.com>
 <20221017205446.523796-2-w36195@motorola.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20221017205446.523796-2-w36195@motorola.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/18/22 03:54, Dan Vacura wrote:
> With the re-use of the previous completion status in 0d1c407b1a749
> ("usb: dwc3: gadget: Return proper request status") it could be possible
> that the next frame would also get dropped if the current frame has a
> missed isoc error. Ensure that an interrupt is requested for the start
> of a new frame.
> 

Shouldn't the subject line says [PATCH v3 1/6]?

-- 
An old man doll... just what I always wanted! - Clara

