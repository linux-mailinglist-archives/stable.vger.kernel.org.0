Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602B43DB7A6
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 13:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhG3LPW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 07:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238403AbhG3LPW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 07:15:22 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA54C061765
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 04:15:16 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id m20-20020a05600c4f54b029024e75a15716so6150489wmq.2
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 04:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=OU8qXUqqKAFOyFA5tQd0rObl29gMPArhi8rvRuKwPE4=;
        b=L2rTxClAjjr063XV7f1Ov9xNxKa+RADAi6fRy1NFCLbqtdEZdHkMlZoyFFXtMeWqVj
         YME0TSap5plenvCBYHGdqhNkJrP3LuN/4sGdg4+z4eT/SvSeBHv3yOdm/ZiwDV/wMVbs
         NLAjYzAPzIAP2TleouvoSZ3/qm645U/OM9zOmP2gyEnKHcdta9tMZI62vN7RpyDTl5TB
         zEtBjK2Nu2htZAnuOOr039tsFXRSHkEBNfel+lp2zL53Y2DwUqtgrT3aWcpnk3TpUuDb
         ngNBxRo8R34PnG3hb+QzyGNDwZQOEQ9Y33hqLKq3+fjczvZtjzYA/o5j5wh9aMhZ/PRg
         lmvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=OU8qXUqqKAFOyFA5tQd0rObl29gMPArhi8rvRuKwPE4=;
        b=sDwrQWkwRjI9IktPEXC1AGsxgoWdU3nRzNQmPs4jIlgE7kLYTPyYAD9gJp4h58vlte
         +EKnJxWVruAOtXiSm8QTK0aF0LND5joEZQUzg3d48oq34bRyaaZHDtr07gP52cWpnu22
         FIEpgK9a4GO12gDn3LGfFzl0gCdyBoSuI4OJYw6+h9mC2hrr+NV+xIyM4afYdTwRXzDV
         kwtsJ+tRqPhqAZ7qzrOlsGihc5fmq2vN0/jTkJrTrBoANtTytWeMFjIgqspyJpYB5ZJ+
         fErMW3wDPlR+RnFENWIWZVqP5KV0mSaPxyJ7KD+vFHi3KEA0ryE3PjERVe+MeJdVRhYu
         q/9A==
X-Gm-Message-State: AOAM532hbWYi/BuObY6tPB2rhuQAX64uImXUkbNNpEBZ/MRd1IIru4yX
        YVeaXjwmfLvDKQIBtl59GGM=
X-Google-Smtp-Source: ABdhPJx7DmqPMtPPF6ohIohQs3zsG00AegDUvivhR6iE6Ew+rdSD7kr77ZLQ3XbxHEfW05faMoKw5A==
X-Received: by 2002:a7b:c416:: with SMTP id k22mr2452145wmi.177.1627643715047;
        Fri, 30 Jul 2021 04:15:15 -0700 (PDT)
Received: from [192.168.11.11] (156.133.46.217.dyn.plus.net. [217.46.133.156])
        by smtp.googlemail.com with ESMTPSA id m9sm1397894wrz.75.2021.07.30.04.15.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jul 2021 04:15:14 -0700 (PDT)
From:   Alan Young <consult.awy@gmail.com>
Subject: Re: FAILED: patch "[PATCH] ALSA: pcm: Call substream ack() method
 upon compat mmap" failed to apply to 5.4-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, tiwai@suse.de
References: <162728697013399@kroah.com>
 <e26c27fb-12e8-f1c1-0dde-50fd68623118@gmail.com> <YQPFqOmmJCJM9Ref@kroah.com>
Message-ID: <acb7f13d-a7bf-8820-363c-98798faa7a09@gmail.com>
Date:   Fri, 30 Jul 2021 12:15:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YQPFqOmmJCJM9Ref@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30/07/2021 10:26, Greg KH wrote:
> On Fri, Jul 30, 2021 at 09:38:52AM +0100, Alan Young wrote:
>> This commit is not applicable before the 64-bit time_t in user space with
>> 32-bit compatibility changes introduces by
>> 80fe7430c7085951d1246d83f638cc17e6c0be36 in 5.6.
> That is odd, as that is not what you wrote in the patch itself:
>
>>      Fixes: 9027c4639ef1 ("ALSA: pcm: Call ack() whenever appl_ptr is updated")
> So is the Fixes: tag here incorrect?
>
> thanks,
>
> greg k-h

I did not add the Fixes tag. I guess Takashi Iwai did.

I think that 9027c4639ef1 added some functionality that was broken by 
80fe7430c7085951 and which my patch corrects. So the Fixes: 9027c4639ef1 
tag refers to the actual functionality, not the breaking of it.

I have no idea if that is the correct usage of the Fixes tag which, as I 
said, I did not add.

Alan.

