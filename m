Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E02D26022C6
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 05:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbiJRDki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 23:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbiJRDkH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 23:40:07 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325D61274D;
        Mon, 17 Oct 2022 20:33:12 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id y191so12929264pfb.2;
        Mon, 17 Oct 2022 20:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PP0ZQ2nPo4v6dAyNNOvsveRPbyFgzn6XfRhZ5WbzBI8=;
        b=fKT5eX3AKAXQus9bKfLGG1J/EW0MXxIb2bAbR5LE8iE31tYYX0xgpa+P4ge0cnt6pi
         1t1VC32u57AHmc2wdWKkn/35CtHn12FU3JxLWD8NCfZwop3/9lviD0/hV+RtKmtjqHXY
         mzofAOkyeYaVhuAwGXipWylUHlv8OYgpre1T0Nbe5GsSQM+xx0SG583/xOUKENFUy8dL
         V2V0KnUn5KeL4CPn3SX3CHk8ZF1hRCBbQGdl5gAhnufF5LXvAQnT5ZkieZzFgm2nOA/0
         A7gbexNrM04ugsexaq3QZsDpGecaQMVcXSQVDxZP8T1KtgZvy9ip8p0+D9j2VtF2iXK5
         T9aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PP0ZQ2nPo4v6dAyNNOvsveRPbyFgzn6XfRhZ5WbzBI8=;
        b=pYbtacTjkIH7UMLut949PTZqx0z8EsuVVB8wE6hEBi4P/Vac6UXhN3t9nHX+t2qNVK
         +BMN7oGbn056VSYluh+sA4IyeEHKVucAMqf7xL/1BNNwpoAE56/WQem0Qwmc8OkktjyD
         R/NgZZoqiTF77qLBtsjvMqZdp6pICge6jXhE9d6vWM2G/9xF7QrP9S8Fuug4iN0zUXXV
         vGQJAWyJnsvFRR9X4s/z8vaiqxY55Ik8mPpNseZ//tov63YK7rS0jt/jtE9Tc0l+RwQw
         HG0sxBTXOQA3yPFMlPfoOksQ58E4rJ2Rkh1ZaXsD5dgn3YSlldNZdas1ouldbtzdMpk+
         dpxA==
X-Gm-Message-State: ACrzQf2ZAymEa06xz1JRTSBpbwycAKlnc/pRalkpnNVw6007zVjx51NV
        Qd+/cmynJOyGHz8LpCZatjg=
X-Google-Smtp-Source: AMsMyM4rxButt95kUTtq6uvHjIhibHmOy89B/oXD3iCL5fSlQqPhqjMzM1h8FccTtvFu0DIVzqiLZA==
X-Received: by 2002:a05:6a00:2291:b0:563:9d0d:62ae with SMTP id f17-20020a056a00229100b005639d0d62aemr1082264pfe.17.1666063991736;
        Mon, 17 Oct 2022 20:33:11 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-84.three.co.id. [180.214.233.84])
        by smtp.gmail.com with ESMTPSA id u15-20020a17090341cf00b0017f93a4e330sm7315946ple.193.2022.10.17.20.33.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 20:33:11 -0700 (PDT)
Message-ID: <e43b596e-e5e1-d928-241f-b89f2861cbea@gmail.com>
Date:   Tue, 18 Oct 2022 10:33:07 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v2] Documentation: process: replace outdated LTS table w/
 link
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Sasha Levin <sashal@kernel.org>, Tyler Hicks <code@tyhicks.com>
References: <Y0mSVQCQer7fEKgu@kroah.com>
 <20221014171040.849726-1-ndesaulniers@google.com>
 <70a859bc-a33b-79f5-6f44-5cccfb394749@gmail.com>
 <CAKwvOd=L7i6iMZ6CRKWpY1yzg5QZj5FM7Rd1HtVFj-6J-qdPtQ@mail.gmail.com>
Content-Language: en-US
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <CAKwvOd=L7i6iMZ6CRKWpY1yzg5QZj5FM7Rd1HtVFj-6J-qdPtQ@mail.gmail.com>
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

On 10/18/22 07:04, Nick Desaulniers wrote:
>> Should this patch be backported to all stable releases? I see Cc: stable
>> on message header, but not in the patch trailer.
> 
> I don't think so; unless people read stable versions of the
> documentation rather than HEAD?
> Perhaps I didn't need to cc stable, but I think that's ok for
> notifying people who are interested in stable, not necessarily
> strictly for backports?
> Either way, thanks again for the reviews+suggestions.
> 

I think most people will simply read the documentation from master branch
(as in docs.kernel.org).

Thanks.

-- 
An old man doll... just what I always wanted! - Clara

