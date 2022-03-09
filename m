Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F894D303E
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 14:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbiCINpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 08:45:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbiCINpd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 08:45:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 38CAE1470C4
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 05:44:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646833474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=bOrpY0Vi0WWmfs0zAz7rF3fjdnoSAkRP9rR10Dishvk=;
        b=HsCkPHWJe6rulhPbmh5GGGng0+ImV6jkKc+QO98CbZu7k2HxMePRI6H2I6jWfSYhKfWIq0
        +rujH50wNQQbfTv52DxGjzhcu8fSpsijyS52BtefieYxtsi+fdTueFhQoJUhQG8gk9bI3W
        UJArcbp6a+QCqXdk48mD9xSauhXQj+Y=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-dRKhQX-WMeK4w1LWsNzzUw-1; Wed, 09 Mar 2022 08:44:33 -0500
X-MC-Unique: dRKhQX-WMeK4w1LWsNzzUw-1
Received: by mail-ed1-f71.google.com with SMTP id cm27-20020a0564020c9b00b004137effc24bso1291634edb.10
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 05:44:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:cc:content-transfer-encoding;
        bh=bOrpY0Vi0WWmfs0zAz7rF3fjdnoSAkRP9rR10Dishvk=;
        b=UWjVaMxtmACPa8ZkwgXqO+SBmH6GE6Fi5GvYCko5vsA2MvQ+e5chUhwmHlz5SqeUAM
         eeWGa4swuGWC8ulvlmc57WC8j3Kcu33T+E4fy9VkeE2Nz/Pv+cPLYhWBM4y2BkTXfN42
         xkGJtKEzekucDegVs+HFwYCcqACVNHtJjXBqXCc2eaE6wCIPzyPZ8gwLDddfTRWd5s9l
         tAxBnvsiMmt5G0W+mloGizxWiy3EQThuW03zmTLqaNYtlKHLDQTR37vH0cQjm5o8zsTF
         eT2sILmjvLtGcVd2ZAagfkDz/yjQmPX7rZ40Jjz5BAZppo0no/zVCIG/iAeYYWHcKd10
         GaXQ==
X-Gm-Message-State: AOAM531jKloxlC60bHY6vzJWqUDl3IMzP2xJOUxAy5NvaibteubzoJdO
        mi9C2/TSBtLuvVOlOde0S+Ngr1ssMYJ+LMlWAWbaZm3NohRXtvXavKrPOi+se0vTEk/5RweZr3x
        VGMQidWZDkuQ6HmKO
X-Received: by 2002:a17:907:3f9c:b0:6d8:116d:476b with SMTP id hr28-20020a1709073f9c00b006d8116d476bmr17712859ejc.432.1646833471995;
        Wed, 09 Mar 2022 05:44:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwR7YvWKpo0YOZA80vGQSSWPnXJB07XNcQ7f+poDh0GD++oCwzYhO25RM7PvhDRUado+ZhzpA==
X-Received: by 2002:a17:907:3f9c:b0:6d8:116d:476b with SMTP id hr28-20020a1709073f9c00b006d8116d476bmr17712835ejc.432.1646833471768;
        Wed, 09 Mar 2022 05:44:31 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:cdb2:2781:c55:5db0? (2001-1c00-0c1e-bf00-cdb2-2781-0c55-5db0.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:cdb2:2781:c55:5db0])
        by smtp.gmail.com with ESMTPSA id i2-20020a1709067a4200b006db720b1231sm544572ejo.2.2022.03.09.05.44.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 05:44:31 -0800 (PST)
Message-ID: <31b9d1cd-6a67-218b-4ada-12f72e6f00dc@redhat.com>
Date:   Wed, 9 Mar 2022 14:44:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Linux PM <linux-pm@vger.kernel.org>
From:   Hans de Goede <hdegoede@redhat.com>
Subject: Many reports of laptops getting hot while suspended with kernels >=
 5.16.10 || >= 5.17-rc1
Cc:     stable@vger.kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
        Mark Pearson <markpearson@lenovo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Rafael,

We (Fedora) have been receiving a whole bunch of bug reports about
laptops getting hot/toasty while suspended with kernels >= 5.16.10
and this seems to still happen with 5.17-rc7 too.

The following are all bugzilla.redhat.com bug numbers:

   1750910 - Laptop failed to suspend and completely drained the battery
   2050036 - Framework laptop: 5.16.5 breaks s2idle sleep
   2053957 - Package c-states never go below C2
   2056729 - No lid events when closing lid / laptop does not suspend
   2057909 - Thinkpad X1C 9th in s2idle suspend still draining battery to zero over night , Ap
   2059668 - HP Envy Laptop deadlocks on entering suspend power state when plugged in. Case ge
   2059688 - Dell G15 5510 s2idle fails in 5.16.11 works in 5.16.10

And one of the bugs has also been mirrored at bugzilla.kernel.org by
the reporter:

 bko215641 - Dell G15 5510 s2idle fails in 5.16.11 works in 5.16.10

The common denominator here (besides the kernel version) seems to
be that these are all Ice or Tiger Lake systems (I did not do
check this applies 100% to all bugs, but it does see, to be a pattern).

A similar arch-linux report:

https://bbs.archlinux.org/viewtopic.php?id=274292&p=2

Suggest that reverting 
"ACPI: PM: s2idle: Cancel wakeup before dispatching EC GPE"

which was cherry-picked into 5.16.10 fixes things.

If you want I can create Fedora kernel test-rpms of a recent
5.16.y with just that one commit reverted and ask users to
confirm if that helps. Please let me know if doing that woulkd
be useful ?

Regards,

Hans




