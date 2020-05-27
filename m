Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D851E468C
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 16:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388982AbgE0O5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 10:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388738AbgE0O5J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 10:57:09 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C702C05BD1E;
        Wed, 27 May 2020 07:57:09 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id l6so21945321oic.9;
        Wed, 27 May 2020 07:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FD3zOvZkpKIQsJ/+WeZ7mwKgRCBWCzByyJC1qop6De0=;
        b=n9v9Cbu6S6tJoT+z12QI/h8gaO1V+5VQcHtR0D+Avm3OO9NeC69bHqwfyCb0KtHItE
         Fi/xCM+AMKmhgvWUDBtM3egvQ0c7t4+lPgkMDnGZ62ZyFjJXyK1Cr1grD8S8Jd9J++FU
         ja7bXJGYSLd4r5QSbUjbNp3MsoRblU2RMohSfAIi4xu+GbPIRQIbe3av/tZciJnaI4Ik
         TfQUsUq9Dgr7lqa2/2qoEbuqSK+VjJLXdw2AHyToSV8uGk3CXYX4Gh3LhbegNQikcqTX
         QY2y8wEtEPgDkKwSS9Rh5/JBzlBhB4LP69UvnUFBw+5lBeaUNnCU5yLXku2klHGvEC0t
         Ukng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FD3zOvZkpKIQsJ/+WeZ7mwKgRCBWCzByyJC1qop6De0=;
        b=VRXWcfBkJ7MJxfs5A+O9CFHWJ8gaKenvav3AUcXC6+GydwgyXWIAdwTCOAJNjFt1aL
         7DY5vNnDCnxN/kmXA8TiRnMl9RP1XUpyTzcEgwxYL7zdYQPjXeTltESMqVD8rXW5ZLZ6
         2yakZIeLeE/bUNrp2gjSTOSQN5IYK/2bGqf6ocGMgs/0VuCAdbiFItQNI5ioMlEwiDmt
         +rMigzFiEAzf2iSHc+rajVb57E83+Z0XVODPTNFeWO2z01AGbYXOKprHjX8E37D89v8c
         kQ5UewMgh2rMF2WZYcuS8bUQxBUGJlFQnN2BIiLwFtTSP5mnBi6c10EUmt0bB0vfNaqv
         COMw==
X-Gm-Message-State: AOAM531RX21BXz1Cqp3YP+DVULoIktVtLT125wXQqNlJAuLJDsjg/Daz
        RnXuEwQu0jNtINscTpujFRbRzmC4
X-Google-Smtp-Source: ABdhPJwnfjZU2gEKHY3PeXsfvDAPqAQkCTpR/fHX4lOzMp9zII3MM/9EBoxatUwGWqpaxa14jJ3azQ==
X-Received: by 2002:aca:4e87:: with SMTP id c129mr3079868oib.9.1590591428265;
        Wed, 27 May 2020 07:57:08 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id d64sm879341oig.53.2020.05.27.07.57.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 07:57:07 -0700 (PDT)
Subject: Re: [PATCH 2/2] b43_legacy: Fix connection problem with WPA3
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        Stable <stable@vger.kernel.org>
References: <20200526155909.5807-1-Larry.Finger@lwfinger.net>
 <20200526155909.5807-3-Larry.Finger@lwfinger.net>
 <87a71tv9g6.fsf@codeaurora.org>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <6375413e-88b2-effa-c972-63eb65a36d09@lwfinger.net>
Date:   Wed, 27 May 2020 09:57:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <87a71tv9g6.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/27/20 7:39 AM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
> 
>> Since the driver was first introduced into the kernel, it has only
>> handled the ciphers associated with WEP, WPA, and WPA2. It fails with
>> WPA3 even though mac80211 can handle those additional ciphers in software,
>> b43legacy did not report that it could handle them. By setting MFP_CAPABLE using
>> ieee80211_set_hw(), the problem is fixed.
>>
>> With this change, b43legacy will handle the ciohers it knows in hardare,
>> and let mac80211 handle the others in software. It is not necessary to
>> use the module parameter NOHWCRYPT to turn hardware encryption off.
>> Although this change essentially eliminates that module parameter,
>> I am choosing to keep it for cases where the hardware is broken,
>> and software encryption is required for all ciphers.
>>
>> This patch fixes a problem that has been in b43legacy since commit
>> 75388acd0cd8 ("[B43LEGACY]: add mac80211-based driver for legacy BCM43xx
>> devices").
>>
>> Fixes: 75388acd0cd8 ("[B43LEGACY]: add mac80211-based driver for legacy BCM43xx devices")
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: Stable <stable@vger.kernel.org>
> 
> I'll do the same changes here as in patch 1.
> 

Yes, both are OK.

Larry

