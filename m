Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B859F6B0D2E
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 16:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbjCHPoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 10:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjCHPoL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 10:44:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95185FA48
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 07:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678290081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uo/FJj1NyWWIzu8ZaV5W6k3pTpM0E/M+diThcFqZLsU=;
        b=IsdxkFnhOi9czN04XIsk3jQ0pTbiQuwdIFYagFrARDfoTQgoPsIn47kEnpDe3X1SpbUmxV
        yjq6HTnr6lbreFHpNI/3IWlehuYK2Ld//ae5r94kLsBdiLHxBsq2oVcW57xLY6i9hpkNIk
        jsGqynvE2AdZDphYYNfDdcoUSjxfNgI=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-543-rFp2F6uJMhmMLFdqj5xCpQ-1; Wed, 08 Mar 2023 10:41:17 -0500
X-MC-Unique: rFp2F6uJMhmMLFdqj5xCpQ-1
Received: by mail-ed1-f70.google.com with SMTP id p36-20020a056402502400b004bb926a3d54so24287105eda.2
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 07:41:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678290076;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uo/FJj1NyWWIzu8ZaV5W6k3pTpM0E/M+diThcFqZLsU=;
        b=hly0g+HpYR1qRvgLUh8dg1N3fJt2EXLeTQlV76GjVcWmsfAxa3viqrKpFNVsUTTYNv
         7/0Gc8wNLn8XZiGHqoP/w32IkvB6xqjbArqKhgkUFKUf41A1fwDWsv5R1a+2c11yiNy5
         auVxPTbziJpo6DE/IAir4faRVCB3mrJoLdnQlUGFfI75eLX3ubI1Hp8XmaTHx8orxALX
         8Ikzy0JrEE8S8Xe39aWdyOpTkUdaEpHSZj/K4P1WxSxQa4PMWA8LhMGliGm6W++8xUSb
         H100uZT1gXTfQsAvQIKykMw3oHJDINph8MDNw7rzlfkMS14tu0s6qsAqNuV5oEj2+DUJ
         8Hlg==
X-Gm-Message-State: AO0yUKUdbQz99FUUfWON1Bi8SCy23BYr9eOnj9yy8mQoBkjxmU+dA0yw
        RLo8dxPwiawJGmrWboJIp6jwyGsEyAPrF8fB8JmnoketQSA9l1GM+M3+Up7lzKGqkws7gHxYNnb
        kxvdy1uORdIZLxGM4
X-Received: by 2002:a17:906:d28c:b0:8e5:88ca:ebac with SMTP id ay12-20020a170906d28c00b008e588caebacmr18273819ejb.40.1678290076502;
        Wed, 08 Mar 2023 07:41:16 -0800 (PST)
X-Google-Smtp-Source: AK7set8Erw9KZCN2gpQm9RxYBdPz3pQC1p8AmgJbv+yXUywJqZjMTGEYSFuokOdDb1SL9rG7IcJjyA==
X-Received: by 2002:a17:906:d28c:b0:8e5:88ca:ebac with SMTP id ay12-20020a170906d28c00b008e588caebacmr18273802ejb.40.1678290076222;
        Wed, 08 Mar 2023 07:41:16 -0800 (PST)
Received: from ?IPV6:2001:1c00:c32:7800:5bfa:a036:83f0:f9ec? (2001-1c00-0c32-7800-5bfa-a036-83f0-f9ec.cable.dynamic.v6.ziggo.nl. [2001:1c00:c32:7800:5bfa:a036:83f0:f9ec])
        by smtp.gmail.com with ESMTPSA id v5-20020a1709063bc500b008c327bef167sm7595126ejf.7.2023.03.08.07.41.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 07:41:15 -0800 (PST)
Message-ID: <09ae066c-7306-1cb3-7cb0-f3ca597290f6@redhat.com>
Date:   Wed, 8 Mar 2023 16:41:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 2/3] usb: ucsi: Fix ucsi->connector race
Content-Language: en-US, nl
To:     Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
References: <20230307103421.8686-1-hdegoede@redhat.com>
 <20230307103421.8686-3-hdegoede@redhat.com>
 <ZAiNgJnNtvPEdIVO@kuha.fi.intel.com>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <ZAiNgJnNtvPEdIVO@kuha.fi.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 3/8/23 14:28, Heikki Krogerus wrote:
> On Tue, Mar 07, 2023 at 11:34:20AM +0100, Hans de Goede wrote:
>> ucsi_init() which runs from a workqueue sets ucsi->connector and
>> on an error will clear it again.
>>
>> ucsi->connector gets dereferenced by ucsi_resume(), this checks for
>> ucsi->connector being NULL in case ucsi_init() has not finished yet;
>> or in case ucsi_init() has failed.
>>
>> ucsi_init() setting ucsi->connector and then clearing it again on
>> an error creates a race where the check in ucsi_resume() may pass,
>> only to have ucsi->connector free-ed underneath it when ucsi_init()
>> hits an error.
>>
>> Fix this race by making ucsi_init() store the connector array in
>> a local variable and only assign it to ucsi->connector on success.
>>
>> Fixes: bdc62f2bae8f ("usb: typec: ucsi: Simplified registration and I/O API")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>> Changes in v3:
>> - Assign connector[i].index before calling ucsi_register_port() instead of
>>   passing i to ucsi_register_port()
> 
> You forgot to rebase this. It does not apply.

Ugh my bad, sorry about that. I'll send out a v4 fixing this.

Regards,

Hans


