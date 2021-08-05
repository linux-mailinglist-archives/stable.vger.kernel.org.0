Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49FE23E1929
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 18:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhHEQLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 12:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbhHEQLU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 12:11:20 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D358C061765
        for <stable@vger.kernel.org>; Thu,  5 Aug 2021 09:11:05 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id e13-20020a056830200db02904f06fa2790cso5676074otp.1
        for <stable@vger.kernel.org>; Thu, 05 Aug 2021 09:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=LSsazpk7vvWcBwueVutBsvrhWVfi85/EcF7Bsz9E/7M=;
        b=QgQdHqrazt8Q5etSzURq5TQgXA61XSk7NMUEEz8v8l6VZqgYRxuXIT/WAS+HBwXftA
         1UH6RcEMbau0+TcVstPctTe2+ULvUFD1H/nYnIMqZpw7F/W8XBA20IN/BGXMYeHlBFBc
         aXEXJjW4Be6rFNCwmxEkZ/uPgBuHKkH9BFyF3UczGkpKwY7VK25WA+0UALFOEWTw0VN0
         jGgmzC3caXPtxULnihVdRoctdtpAiUuXuPhCOquZcTY40qioBS+j07BvXAqwVWiSxQYL
         H4kDioB/2GBGi2OxClwxsf/Tq+0Q0eHPwfBaQOFOs8x2TZOv0uPBcufRf4sNoOOVZ26X
         bD7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:cc:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=LSsazpk7vvWcBwueVutBsvrhWVfi85/EcF7Bsz9E/7M=;
        b=Sjw0jGp6UJjEXNJ6aCHmbItECxrXEwOPKgScv/pM2MgxVV0v7rECY2gMfPG9bz2JGB
         f+7wnN3auAI12R4OR4L5N8pGgBtg7wTyrGVDCXMpglUcvMSrlM4nHNTh3JzGWGup/BCO
         Vrz1Cc3Jr6u5p2QDUI85x8ODZjgot8AwiIkQpv7//4ZSs7tYr3pELnh70X3Wf88kP5Zz
         r2DH9fe9FYi2fWzZ8jG63d5GGVnxbsFdV7pWI6Udn3cnN2blwIkS98yriGWcldgkG8/f
         sTJ8HmN92rYzCbfJyebpU7gVVjZIEi6e4bFJfySRqYUUxPYqf9MGk252AAl5qClaMpTj
         ML+Q==
X-Gm-Message-State: AOAM532W/mmKI7/xix5ekblFVSAiWChbRm3y76rdbU7TmmCTu/Cu1V6c
        lasBVuNDZVTYBch9rU6HDC4=
X-Google-Smtp-Source: ABdhPJwszS0tB6O14SK3QGFoRIsvzIsAZDgiQbocdbwRZ2W5CI9Vt4sloTXlMLUMVdyDuD1+lHc0Aw==
X-Received: by 2002:a05:6830:1bf3:: with SMTP id k19mr1304165otb.335.1628179864809;
        Thu, 05 Aug 2021 09:11:04 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s2sm857301ooc.15.2021.08.05.09.11.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Aug 2021 09:11:04 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Regressions in stable releases
Message-ID: <efee3a58-a4d2-af22-0931-e81b877ab539@roeck-us.net>
Date:   Thu, 5 Aug 2021 09:11:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi folks,

we have (at least) two severe regressions in stable releases right now.

[SHAs are from linux-5.10.y]

2435dcfd16ac spi: mediatek: fix fifo rx mode
	Breaks SPI access on all Mediatek devices for small transactions
	(including all Mediatek based Chromebooks since they use small SPI
	 transactions for EC communication)

60789afc02f5 Bluetooth: Shutdown controller after workqueues are flushed or cancelled
	Breaks Bluetooth on various devices (Mediatek and possibly others)
	Discussion: https://lkml.org/lkml/2021/7/28/569

Unfortunately, it appears that all our testing doesn't cover SPI and Bluetooth.

I understand that upstream is just as broken until fixes are applied there.
Still, it shows that our test coverage is far from where it needs to be,
and/or that we may be too aggressive with backporting patches to stable
releases.

If you have an idea how to improve the situation, please let me know.

Thanks,
Guenter
