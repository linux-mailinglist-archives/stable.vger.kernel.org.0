Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAF87125CB2
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 09:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbfLSIax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 03:30:53 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44731 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726652AbfLSIaw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Dec 2019 03:30:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576744251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ewCaJOfBy9nGeq4Yo9i7Tisg8do5u5i6meu8ilRSTEg=;
        b=DtUO9wTFa47tUrjPS3d4Ul0kC+aew3j/Mqcbc9o9Jlns13p93B1TTC1Ye+74lnaEmUv+Db
        jFOD9wCaWq2gxisvwdu+BVliHkFgosqJz0rQx9jKlFX2MtlyhBwO3WKSRJHMs3hwKrccfZ
        JFS3ZZJu0C2JHI7mFHmWN4pVFgcuIo8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-o5gLTIWKMDaJ33Ny_25qPg-1; Thu, 19 Dec 2019 03:30:41 -0500
X-MC-Unique: o5gLTIWKMDaJ33Ny_25qPg-1
Received: by mail-wr1-f72.google.com with SMTP id z15so2081911wrw.0
        for <stable@vger.kernel.org>; Thu, 19 Dec 2019 00:30:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ewCaJOfBy9nGeq4Yo9i7Tisg8do5u5i6meu8ilRSTEg=;
        b=MnuXkqpl9jVh1dm/QyKQfISnMjU9liYCheaqcqq7Nb7PdmZgJYETB5QuuMvLos6OCF
         IjeZuL3+C5QE+WWQ6CStmw0FYwjib7Vi8tqO1LTxbhIUp2czBrMj/Kda9vdbfWN305c9
         QG5e9o5vEWn0qHVnVIanMMqNSdU78RFRJPK5zg1UslBtPRST0L4JxOljHSL3xXoGkkVJ
         HVbRL54k2CExbUE4vVkl5+gYlBw5qI/I5TJxC3NBfP9W5/ZMqRAp/i0HGjrRphTRMy0X
         vFjvaHuvZ7/TB8z41fYmVFIRDHc92oTXECyDbvhA0tuXzwv1uvwsQfAMyY5DSZYnGDYe
         LzAA==
X-Gm-Message-State: APjAAAW2xq+OQEafRph6vlne6bdt5hoG0QZ15xdPagIwIWibi/T0nB63
        Zwae/ez3YC/BNblvUCeS3qltcE4heja7kEHOcOL4qnm39SHBt7Q9Ut8GhBS/eJrk1gRoVnBMhEK
        W2zK9rN7blrsttxdN
X-Received: by 2002:a5d:5708:: with SMTP id a8mr8421057wrv.79.1576744240551;
        Thu, 19 Dec 2019 00:30:40 -0800 (PST)
X-Google-Smtp-Source: APXvYqza16homzGLdCX3FZ2ghQQQEoyB9HUoq4Lc+0whtn5OtM6iey5RpTK+S2JgsXBTOpT2hWKVDg==
X-Received: by 2002:a5d:5708:: with SMTP id a8mr8421038wrv.79.1576744240393;
        Thu, 19 Dec 2019 00:30:40 -0800 (PST)
Received: from shalem.localdomain (2001-1c00-0c0c-fe00-7e79-4dac-39d0-9c14.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:7e79:4dac:39d0:9c14])
        by smtp.gmail.com with ESMTPSA id e6sm5586381wru.44.2019.12.19.00.30.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Dec 2019 00:30:39 -0800 (PST)
Subject: Re: [PATCH] serdev: Don't claim unsupported serial devices
To:     Punit Agrawal <punit1.agrawal@toshiba.co.jp>
Cc:     linux-serial@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, nobuhiro1.iwamatsu@toshiba.co.jp,
        shrirang.bagul@canonical.com, stable@vger.kernel.org,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>
References: <20191218065646.817493-1-punit1.agrawal@toshiba.co.jp>
 <096046b6-324a-8496-8599-ed7e5ffc6e3c@redhat.com>
 <87eex1noak.fsf@kokedama.swc.toshiba.co.jp>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <a2e86d54-287a-16b4-3dac-9e3fe3dee753@redhat.com>
Date:   Thu, 19 Dec 2019 09:30:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <87eex1noak.fsf@kokedama.swc.toshiba.co.jp>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 19-12-2019 01:37, Punit Agrawal wrote:
> Hans de Goede <hdegoede@redhat.com> writes:
> 
>> Hi,
>>
>> On 18-12-2019 07:56, Punit Agrawal wrote:
>>> Serdev sub-system claims all serial devices that are not already
>>> enumerated. As a result, no device node is created for serial port on
>>> certain boards such as the Apollo Lake based UP2. This has the
>>> unintended consequence of not being able to raise the login prompt via
>>> serial connection.
>>>
>>> Introduce a blacklist to reject devices that should not be treated as
>>> a serdev device. Add the Intel HS UART peripheral ids to the blacklist
>>> to bring back serial port on SoCs carrying them.
>>>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Punit Agrawal <punit1.agrawal@toshiba.co.jp>
>>> Cc: Rob Herring <robh@kernel.org>
>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> Cc: Johan Hovold <johan@kernel.org>
>>> Cc: Hans de Goede <hdegoede@redhat.com>
>>
>> Thank you for addressing this long standing issue.
> 
> I am surprised there hasn't been more people complaining! Maybe even on
> x86 mainline isn't that widely used on development boards.

I think it is also a case of there not being that manu x86 development
boards.

Regards,

Hans

