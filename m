Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01595100BE3
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 19:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfKRSzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 13:55:03 -0500
Received: from mail-wr1-f41.google.com ([209.85.221.41]:46524 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbfKRSzC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Nov 2019 13:55:02 -0500
Received: by mail-wr1-f41.google.com with SMTP id b3so20794080wrs.13
        for <stable@vger.kernel.org>; Mon, 18 Nov 2019 10:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=Yj6BBWnOeT3Z+h9P07RBdnq4tpIa0vsilaI+lMcEHPQ=;
        b=MpbTFyeLGbKxsT/zg1MAVxNlJZVTc4m1R4CVYi0ezuH3eBHXgRELb5pff6uYCcZC0S
         Iv+Vs5YqKEqFef2XAB2xHm5GqcGHvtMSXOfcswi3i3nIARNfyA+E+/ON7vUCp5TblKj2
         6C/6Z1keTEL9tn1mFzKOUNd9o6QqEMFM4mxv7mptWauVYI/lKnWiOUfJE8FJxL2wJHcf
         +6qdCuehQTB4gY6Zis4LB5xVpIg/8NseEgpb5AklT8JozR1ADhAOTuqg/LFos7mKMsrS
         SgUmoK80Y+Y3eOoFrVQjnvaVGjxcvFa07/kAEWp52fpTm2bYEXzHDTlTXly+7F4PfPkt
         XOvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=Yj6BBWnOeT3Z+h9P07RBdnq4tpIa0vsilaI+lMcEHPQ=;
        b=qtrkfoTfEDBKt55S6XgkWJtrWab52Fc3Gv1253e6laCP0UkRKB/MpcABRGyyFG9Tq9
         O9ARCHvugZ/C+ua42sn+KDLhpz1GKs8m3SdMAYwUaOZMv9cFOO1bqwcSyhKq7ayOxJs9
         lHugbVfschyxQuMA/fD43tVXPqRheB52qjY8RhVKWCquABcyn4v0UXSrlmMWap65cC9j
         8QICr55zw1U2ijKAD91e3EUDLilq+dzBjm6kWRWqELvjHhyozicvuHrDFm9/0FkQyKau
         68NEt09XJQcNntVXt57V1R4O856R5BFRBhBzUs7eBxhq6oxfNCe8RJfM0IBVDz5dpDZT
         mO3w==
X-Gm-Message-State: APjAAAVTQ6P21txSgowEea7DrG38bOISvc9b7kdsoLcWgG0W+RtU9sx9
        JR9DXuRwvFAEfCp6c2yT1q680dPmVHYjOQ==
X-Google-Smtp-Source: APXvYqyOA1EZxDR0QbzGTsk9YXMVtIMZo5wXTIWswmL/OI6/+gr+TSw0C8w43Ifaltgf2v1oaeJHPA==
X-Received: by 2002:adf:9323:: with SMTP id 32mr31992053wro.15.1574103300238;
        Mon, 18 Nov 2019 10:55:00 -0800 (PST)
Received: from [192.168.1.2] (host-109-89-151-97.dynamic.voo.be. [109.89.151.97])
        by smtp.gmail.com with ESMTPSA id d18sm24860391wrm.85.2019.11.18.10.54.59
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2019 10:54:59 -0800 (PST)
To:     stable@vger.kernel.org
From:   =?UTF-8?Q?Fran=c3=a7ois_Valenduc?= <francoisvalenduc@gmail.com>
Subject: Size of the stable-queue git tree
Message-ID: <95023b9f-1281-b74b-cae0-0516ee4ceb90@gmail.com>
Date:   Mon, 18 Nov 2019 19:54:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: fr-moderne
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello everybody,

I pulled the stable-queue tree just now. This was not an inital clone,
but only an update. My previous update was end of last week I was
surprised I had to download 1,19 Gb to download.

Can somebody explain why this was so large ? This is probably the first
time I notice this. Usually, updates are much smaller.

Thanks in advance,

François Valenduc

