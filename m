Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E9665B332
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 15:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236157AbjABOJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 09:09:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjABOJG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 09:09:06 -0500
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B5E6595;
        Mon,  2 Jan 2023 06:09:04 -0800 (PST)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id A39E660027FC1;
        Mon,  2 Jan 2023 15:09:02 +0100 (CET)
Message-ID: <664cb6b8-3f84-8627-cb35-52fdabad186c@molgen.mpg.de>
Date:   Mon, 2 Jan 2023 15:09:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Problems with delivery to dalias@libc.org (was: [PATCH v2] matroxfb:
 G200eW: Increase max memory from 1 MB to 16 MB)
Content-Language: en-US
To:     Helge Deller <deller@gmx.de>, "Z. Liu" <liuzx@knownsec.com>
Cc:     it+linux-fbdev@molgen.mpg.de, Rich Felker <dalias@libc.org>,
        stable@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20230102140206.6778-1-pmenzel@molgen.mpg.de>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230102140206.6778-1-pmenzel@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Cc: Back to dalias@libc.org]

Dear Linux folks,


Please ignore version 2.


Am 02.01.23 um 15:02 schrieb Paul Menzel:

[…]

> ---
> Update Rich’s address.

I should have read the undelivered message better:

```
<dalias@libc.org>: host brightrain.aerifal.cx[216.12.86.13] said: 
550-Message
     blocked for policy reasons: 550-Your mail system is forging its 
hostname.
     550 Message could not be delivered (in reply to end of DATA command)
```

I got the same for dalias@aerifal.cx. No idea, what is supposedly wrong 
with our setup:

     $ host mx.molgen.mpg.de
     mx.molgen.mpg.de has address 141.14.17.8
     $ host 141.14.17.8
     8.17.14.141.in-addr.arpa domain name pointer mx.molgen.mpg.de.


Kind regards,

Paul
