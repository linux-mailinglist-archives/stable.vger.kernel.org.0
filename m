Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22C10529597
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 01:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350480AbiEPXx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 19:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242639AbiEPXx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 19:53:28 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0790B3ED2F
        for <stable@vger.kernel.org>; Mon, 16 May 2022 16:53:28 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id i9so1246860edr.8
        for <stable@vger.kernel.org>; Mon, 16 May 2022 16:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:to:cc:references:subject
         :content-language:in-reply-to:from:content-transfer-encoding;
        bh=faSFFFCYgfZhm7yFYiEZrr+4wyXWLD1FhtB7m1b/5Ns=;
        b=h9sz0Fc4Xny9nOcmF7rpJGLVKhQcaT4iVe4oKE1ton9uhzWzSwGPufhVXFqmN2ng/k
         7xePaGh0MY1MdkVtVoP1ZYbWz8TkpxcPniTX3et02AN0FHKQ53p0rIaqUXLi+A3bs0AJ
         jYMKFdYF1DOg6HNu4z7RBbEAQF5tly+3RzGFPC4cFLxjUoDLKezKrvKkF46ng0DEvgx9
         +iiGUwZ0OfFV4AVFnfYF9N0d5Ig6I+O4mh4shh5h5HztJTIv8ByDocC9VVP1Nt9F2jLt
         DF5YenWlxGdMqqCgAK2gCb+dMpTywSAc2CLSSuNODxF7vR1Jca9JT5hNWKKrtbMQvVkt
         /JzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:to:cc
         :references:subject:content-language:in-reply-to:from
         :content-transfer-encoding;
        bh=faSFFFCYgfZhm7yFYiEZrr+4wyXWLD1FhtB7m1b/5Ns=;
        b=205Cj5S4IZVpzHRHhW4W1tdN6UdcfnDI+6Mzuaz1Mrlz/4ZxLwVUqP7hgokYVK6F8p
         Co328CeIUpdg7u7I0rTwLD+1PvPHPmdFqraTFVvMPwEG523/s1j1qbueyJ5Jyn06pvhA
         rlXPhOFz/sWtL+UCDNaYTQE8BVCEFZxs3g7gLvQU5bcknvvGhbZVxEcXRfubkXGjxEgo
         PMd3Cy6GvocGBM9R1L05nEvfpY0cwgVKsaZ75zdPCY6fRQCqmi4WwAMIk8aBDt3ZtEc5
         YMAsIe53MLmIrLRJuQ72sJdRmgEG+9aPWijZu6VV9/rm2vXyAGPGQ5L81/d9pumu5Y7E
         +36g==
X-Gm-Message-State: AOAM530FCgVN3MnpFqptXQ+kE7OqZX52bBEr1kOjbDfx0r6R04UnVDfo
        woZsO/lRJ29RR+ZfJhKYvTU=
X-Google-Smtp-Source: ABdhPJwb/F4Y7l6ajled1hbWRATI/4fqkYMtJ7Rcb8EMEf8glJfqC9e5d3kCq6FVUQ7GLXu2fA2UiQ==
X-Received: by 2002:a05:6402:206f:b0:42a:a8c1:1637 with SMTP id bd15-20020a056402206f00b0042aa8c11637mr11040288edb.302.1652745206545;
        Mon, 16 May 2022 16:53:26 -0700 (PDT)
Received: from [192.168.1.110] ([178.233.88.73])
        by smtp.gmail.com with ESMTPSA id u2-20020aa7db82000000b0042617ba63a7sm5906624edt.49.2022.05.16.16.53.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 16:53:25 -0700 (PDT)
Message-ID: <c2163c71-2f71-9011-3966-baeab8e8dc8f@gmail.com>
Date:   Tue, 17 May 2022 02:53:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
To:     marex@denx.de
Cc:     alexandre.torgue@st.com, alsa-devel@alsa-project.org,
        broonie@kernel.org, stable@vger.kernel.org, tiwai@suse.de
References: <ee74ed25-cd10-1047-9700-7546c7ee7052@denx.de>
Subject: Re: [PATCH] ASoC: ops: Shift tested values in snd_soc_put_volsw() by
 +min
Content-Language: en-US
In-Reply-To: <ee74ed25-cd10-1047-9700-7546c7ee7052@denx.de>
From:   "Tan N." <tannayir@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The same changes that are applied to the snd_soc_put_volsw should also 
be applied
to the volsw_sx and xr_sx put callback functions.

Most of the Qualcomm codecs set the volume levels of controls like this
-- SOC_SINGLE_SX_TLV("IIR1 INP1 Volume", LPASS_CDC_IIR1_GAIN_B1_CTL, 0,  
-84, 40, digital_gain) --
which causes the values from the caller to be rejected incorrectly on 
the put callback function.

It took me a lot of time to debug this but because those two functions 
aren't changed
in this patch, it creates an issue where some Android phones have extremely
high amplification on the sidetone mixer during calls which in turn causes
a feedback loop because the kernel can't set the correct level on the 
controls.
