Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859C549EE13
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 23:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240706AbiA0W3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 17:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240436AbiA0W3J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 17:29:09 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87EABC061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 14:29:09 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id s5so9459428ejx.2
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 14:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=do72kXsRevUeXSBUvSVcP0uCjTUp/jstI3i2Pbu7YE4=;
        b=AM/t+5fztax5qLsnq/8KRnnDWaRSxmfQRz8bK6SR++bD7BP749GtzSW2SNTT6qcaas
         WllYOwanNErI9WGzwfW3Q4LB0veV4WimV6zxCISX36zd6DNo6iJDuNAFZp29p8lXQqnF
         XiAQN4fFAhQ0QWgEsD/TLB5RytjECApWPc1uAaTQhEBE7eVWLRKEv5/GKhDZkE/t3TF4
         SO+8MArGHsSBMwbQQGyKHvrSWt6eEpHHG2UZKiENZWFCghDKN40Udsp1ey2Zof1l4Ip0
         VdWDepZaG9YMQiaAr1sSGquGeID+/6RMoZY8FEiUpYe4nlNFQiLjXKuyJ1v18DtAjEQ2
         p2Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=do72kXsRevUeXSBUvSVcP0uCjTUp/jstI3i2Pbu7YE4=;
        b=Z4Ssxvlzv9Ou85TvqREEf/m128An4tPlHu3MhghQrvTfa8H7nr9vnUxVp0XNT/W89K
         x1EaitokygH7LFFuoUaE6Dd4azLO5V/ZUUOvMY5khk0AXC37jDOK+N7aCioVnJR4WxwR
         YgIBQWJ3h8Xnp7szvxvcb4k5AwHHuGuralDC1r6jFKv/ZQn0TpWdCvmda0NkyG3HQmX4
         OAMvHn+sVFjmVr8BPlmeVbu0KEEqHvOfZEcmAiLrj0AVZOhvaRu7sIhcvWesEOZa+Rio
         b7HkqTOn3fUwrl/u2GdoBYRY6qgTgKO+lu+EkySQk716yx2EbaETcI5uBRgFY7Ybna7t
         34pQ==
X-Gm-Message-State: AOAM532HprU3Mb0OqqBMBanyJeBXPw4Ors21XBE18tugABfWC1FAfaeQ
        wGXqTdfeRZhKGDDm745QsBLpT1M9Zx2SJ+vRO4NSfg==
X-Google-Smtp-Source: ABdhPJwKZEKHj7MR/Xv1BsQZi73Kw8FnoGvLybOs6Ent2MGJgfu3qdZW/GKIlXvN1WLnUDo+dtfXt1c6S+b0oFa2hVI=
X-Received: by 2002:a17:906:eb8a:: with SMTP id mh10mr1667019ejb.492.1643322547862;
 Thu, 27 Jan 2022 14:29:07 -0800 (PST)
MIME-Version: 1.0
References: <CAOiWkA-_CJ7VXEo8NicmFqi_3Z78A4662x-ydrH2F4YA+qibwQ@mail.gmail.com>
 <CAOiWkA_HQrnhDOOKWfXd3eP_e0g68vWiaGP361DAhvENdh=4Tw@mail.gmail.com>
In-Reply-To: <CAOiWkA_HQrnhDOOKWfXd3eP_e0g68vWiaGP361DAhvENdh=4Tw@mail.gmail.com>
From:   Guenter Roeck <groeck@google.com>
Date:   Thu, 27 Jan 2022 14:28:56 -0800
Message-ID: <CABXOdTcCJC2Xt-5iRkCtEZnU6FGn+CChu30LDgW9NP=eUzSBWw@mail.gmail.com>
Subject: Re: issue with patch: media: venus: core, venc, vdec: Fix probe
 dependency error
To:     Martin Faltesek <mfaltesek@google.com>
Cc:     bryan.odonoghue@linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 27, 2022 at 1:44 PM Martin Faltesek <mfaltesek@google.com> wrote:
+stable@
>
> +gregkh@linuxfoundation.org
>
> ddbcd0c58a6a is upstream fix for this and needs to be applied to affected stable releases.
>
My little tool tells me that this is only needed in v5.10.y.

Guenter

> On Thu, Jan 27, 2022 at 3:21 PM Martin Faltesek <mfaltesek@google.com> wrote:
>>
>> Hi Bryan,
>>
>> I was merging this patch into our code base that was in 5.10.94:
>>
>> commit eeefa2eae8fc82ad757a2241b9f82ac33e99e6b4
>> Author:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>
>> AuthorDate: Fri Feb 5 19:11:49 2021 +0100
>> Commit:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> CommitDate: Thu Jan 27 10:53:51 2022 +0100
>>
>>     media: venus: core, venc, vdec: Fix probe dependency error
>>
>>
>>
>> @@ -364,11 +365,14 @@ static int venus_remove(struct platform_device *pdev)
>>         pm_runtime_disable(dev);
>>
>>         if (pm_ops->core_put)
>> -               pm_ops->core_put(dev);
>> +               pm_ops->core_put(core);
>> +
>> +       v4l2_device_unregister(&core->v4l2_dev);
>>
>>         hfi_destroy(core);
>>
>>         v4l2_device_unregister(&core->v4l2_dev);
>> +
>>         mutex_destroy(&core->pm_lock);
>>         mutex_destroy(&core->lock);
>>         venus_dbgfs_deinit(core);
>>
>> This section introduces  unregistering twice, before and after destroy.
>> I think there must be a patch that fixed this since this error does
>> not exist in linus's tree.
>> I'm guessing there might be a missing patch you'd want to grab.
>>
>> Can you comment on this?
>>
>> Thanks,
>>
>> Martin
