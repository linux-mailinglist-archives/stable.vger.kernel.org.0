Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 621AD45E31
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 15:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbfFNN3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 09:29:41 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46840 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727970AbfFNN3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jun 2019 09:29:41 -0400
Received: by mail-qt1-f195.google.com with SMTP id h21so2363853qtn.13
        for <stable@vger.kernel.org>; Fri, 14 Jun 2019 06:29:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IHyZjXMqJlpbjocW6TRirsZ/j5VR+yIzk8AHQxGtp30=;
        b=g4hs1OP2uDlLbZeo37qYhFEsYkA67xbY1oBaLarYfol3QE6uBpZ0bN43SttWSNn7Xd
         s8tEjtB91Sb1ozB0XfRTvOMvksmM+U0YUu0AURghG/3sT6Xfz5flIygezBKXmw60feLN
         M9taP+cfm4NvUwWN02U693+ILEQcCTqfgRB82B2eZaIGoFnBxIdPNP5iyFHRxXLKLGQx
         eew76+ep0YB1Zh2qJdC4JGTe3Gtb4x3JT8rLi3XZoqwd3TIyCTkVNJanDDplfFWAJXvO
         wKr/V36z6V1g6U0CWGIJfIUh6Kd92SIIHLk6JWPTz6JIFzDZC+ry+wh4XizUjWvrJckQ
         KgZA==
X-Gm-Message-State: APjAAAVYxU/6kPGAYZR1HACo5UdBG+vQr+RjkCQKy6jyxKABNiMMbpjT
        XYDQvbBq3UdKoh0Ei2adXTMsvl3Y
X-Google-Smtp-Source: APXvYqxAQWGBjmM6LjfEEzZrC8V8WYcp7ExN8XPZ1Xq30Vseb2p3huYqpI+wrrB5OQ37ZIu99FJXgg==
X-Received: by 2002:ac8:252e:: with SMTP id 43mr73187916qtm.61.1560518980286;
        Fri, 14 Jun 2019 06:29:40 -0700 (PDT)
Received: from [192.168.15.185] ([4.15.170.198])
        by smtp.gmail.com with ESMTPSA id q36sm1944911qtc.12.2019.06.14.06.29.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 06:29:39 -0700 (PDT)
Subject: Re: [PATCH stable-5.0+ 3/3] nvme-tcp: fix queue mapping when queue
 count is limited
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <20190610045826.13176-1-sagi@grimberg.me>
 <20190610045826.13176-3-sagi@grimberg.me> <20190613074516.GB19685@kroah.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <2efe1238-b183-6a70-25a5-d31666a1df17@grimberg.me>
Date:   Fri, 14 Jun 2019 06:29:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190613074516.GB19685@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Its on its way to Linus...

Should I just respin again once it lands there?
