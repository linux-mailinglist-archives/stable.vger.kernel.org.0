Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0023E5FD6E3
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 11:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiJMJUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 05:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiJMJUg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 05:20:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44CD844E2
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 02:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665652832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w3TgGK5EEsPObRlrqnyHLb3HIblxwOM4CU6fhnBVGHU=;
        b=b8ZRBj3vMl4f3lVWhbekqwPaO8jSOIRHdeUrjrcK/wEdRKwlKuX2iZDp0LppfHpjsNJY0K
        HTM5G0CBHjItf5WQWcQihbUe5dlV33wakJo2svkqUXBnia5GlGzQXMjBOaYMwIdxzI6ZDS
        sKFBtWaaujL5E3ePzgc7sMieCNQGoeE=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-669-T81I95GyOKu3o6XXYbixyw-1; Thu, 13 Oct 2022 05:20:31 -0400
X-MC-Unique: T81I95GyOKu3o6XXYbixyw-1
Received: by mail-pf1-f198.google.com with SMTP id t21-20020a056a0021d500b0056358536cdeso914814pfj.22
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 02:20:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w3TgGK5EEsPObRlrqnyHLb3HIblxwOM4CU6fhnBVGHU=;
        b=zb4E0tgs2pXKEgWZ/rejtyDdiv3TfZG1bZ6L1czFrJRCZQCTV4Kg26CjsclEF4b2e2
         FhuYM3ZsWLFQw46Y3crLG9xkNto0bTA9984dNGz/8zZz/+CmbdCCDlY7cg9NjVkDCTKu
         dVLW6MPC1//3y7aGYPqFjY5D50msuei2eX6aSmtyGR8rwEzJn04krV7GCF4CaPEgWGRR
         8u2uHEKMSKTqwg0NHuK6qFUYv8sFwHmksSJDPTpsok+rkW9iU/+HbKFO1J7zzTAQzxru
         4cxOUWcnNkKlFr6HuTm16g+okGPx4sm0lPbxWf9uulrI6m6v1FDBbfVjDFsz7pPUPtCI
         OEWA==
X-Gm-Message-State: ACrzQf1c6UzUaFVZZ6iZ0UZG6SIORKullMuNXDBkiXwVfkYAYHAsFDkV
        MxDf9/TQgmrqBPo7CuBjlqcJ2XNH0h3ditJQVe85enjq/hwn/7mSaFpB2xL2smL1lvUQvfZ+64j
        n+KUoB+M1nf0QZ4PUX/2q4+3Kysabaqibj7vcvAWnbeUkTKXvWTNmSoyb6024xF491g==
X-Received: by 2002:a17:902:efc9:b0:183:88ed:d15e with SMTP id ja9-20020a170902efc900b0018388edd15emr14246830plb.139.1665652829895;
        Thu, 13 Oct 2022 02:20:29 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7LV0LGd+WCSNQtk0TrY9veeGIdJ8Lxcp1tnAa1c5OVMhImKLaQ9ahRjgxWNkP7Bk7BGMsI6w==
X-Received: by 2002:a17:902:efc9:b0:183:88ed:d15e with SMTP id ja9-20020a170902efc900b0018388edd15emr14246800plb.139.1665652829454;
        Thu, 13 Oct 2022 02:20:29 -0700 (PDT)
Received: from [10.72.12.247] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id i1-20020aa796e1000000b00560bb4a57f7sm1467346pfq.179.2022.10.13.02.20.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 02:20:28 -0700 (PDT)
Subject: Re: ceph: don't truncate file in atomic_open
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <59d7c10f-7419-971b-c13c-71865f897953@redhat.com>
 <20220701025227.21636-1-sehuww@mail.scut.edu.cn>
 <f87ea616-674b-2aad-f853-c28ea928ad4d@redhat.com>
 <Y0fWbKksISUWcCeA@kroah.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <0130f352-cf2a-ab9a-3da9-8aae1bd464ca@redhat.com>
Date:   Thu, 13 Oct 2022 17:20:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <Y0fWbKksISUWcCeA@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 13/10/2022 17:12, Greg KH wrote:
> On Wed, Oct 12, 2022 at 09:51:43AM +0800, Xiubo Li wrote:
>> Hi Maitainers
>>
>> This patch is a fix in kceph module and should be backported to any affected
>> stable old kernels. And the original patch missed tagging stable and got
>> merged already months ago:
> Does not apply to the trees, sorry.  Please provide a working backport
> if you wish to see it applied.

Already sent it out and I saw your have applied to them.

Thanks very much!

- Xiubo


> thanks,
>
> greg k-h
>

