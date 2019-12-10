Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51ECF1194F5
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbfLJVR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:17:27 -0500
Received: from mail-pg1-f174.google.com ([209.85.215.174]:37929 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729141AbfLJVM5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 16:12:57 -0500
Received: by mail-pg1-f174.google.com with SMTP id a33so9263972pgm.5
        for <stable@vger.kernel.org>; Tue, 10 Dec 2019 13:12:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RVHzytoFKmxp71fLK8zwWumSvcrUcgiercZQ4sj+tQs=;
        b=Y4KqN8Z1+G+DQ6I91zdwl1tThKHZXbN9IHG/kHPpbi0qD92ARIlURi3zrreR0AwTsD
         rsS4Jmih+9ruNqRgghQd0c/2BhPfQtvrEjbCCoNPEvqiHiXl3nCOI/eihg80yv1VnHSV
         JmAnVICy1mOltAk5W2ESvsPdlbr69KcnAuvDaQ17hTMQxeAH7C6IBe9WdwJsgVe2KTPD
         9Or8XaQ6nOAMMhSy+uHid04DnkDizHdFsnulLf4BU6fjbxCzoF5i4SNxMRMCeVyI+V1P
         bBi0BwQaG+34AfPgmWEFeXSC/I4GNBZcddxqm8/bPUQmqDSa+7p10Ieyz8bzxEENVTQH
         j+1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RVHzytoFKmxp71fLK8zwWumSvcrUcgiercZQ4sj+tQs=;
        b=POjBVF0mYnt5U4xZNI0e+S7drZKzQ5S0rSGensaGlPtnbx4plDE4FELqHw9KcO58N/
         wkyMb7E5Ip7mZeVLt9SHLBI9EPBR1hxu0mMBRjgh2I/namQT7lX0cXzvbgljwKN8L+Vw
         3EWTA7jrpb7DjKt5jAYTkfx/a/nH/3Q7WlWyXoi4LCPlVfv7293812AhVj3BCzfPwhYH
         edV3Fsk/ctPLkU6ayRFLj17v6Zxf02IMdXUTEoHhQKSrhpzcMaEKcOxkvpT/aeoWn7VX
         6Wu474O1SPYppGHGbWToQu9Hb6Ra1eW3jQR4s0C96ZHipHOL0Lq5jfE4fTMbeqETbqdI
         gorA==
X-Gm-Message-State: APjAAAUjRTv1lz9Wr5BsP2aaJBRpcdTf05aOjlFo4eMWDIa8g6yZSl9Z
        nYdGuU9jIhrKVCnbJ0fcpUQf2w==
X-Google-Smtp-Source: APXvYqyjzdzfwzhpwgSViB4SArfQ8GAco9voKZJjasYu5IC6XOdvTr7bF/yg/61DwxdTvHIWA6+4DQ==
X-Received: by 2002:a62:1548:: with SMTP id 69mr37952583pfv.239.1576012376620;
        Tue, 10 Dec 2019 13:12:56 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1131::1215? ([2620:10d:c090:180::4a7a])
        by smtp.gmail.com with ESMTPSA id b16sm4394227pfo.64.2019.12.10.13.12.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 13:12:55 -0800 (PST)
Subject: Re: [PATCH 01/11] io_uring: allow unbreakable links
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org,
        =?UTF-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>
References: <20191210155742.5844-1-axboe@kernel.dk>
 <20191210155742.5844-2-axboe@kernel.dk>
 <e562048a-b81d-cd6f-eb59-879003641be3@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <15eb9647-8a71-fba7-6726-082c6a398298@kernel.dk>
Date:   Tue, 10 Dec 2019 14:12:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <e562048a-b81d-cd6f-eb59-879003641be3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/10/19 2:10 PM, Pavel Begunkov wrote:
> Apart from debug code (see comments below) io_uring part of
> the patchset looks good.

Hah, oops!

> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

Thanks

-- 
Jens Axboe

