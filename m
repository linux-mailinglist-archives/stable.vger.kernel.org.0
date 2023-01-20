Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDD16753EE
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 12:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjATL4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 06:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbjATLz7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 06:55:59 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F58A1007
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 03:55:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1674215749; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=QPtbicNOTpATkxKByWMdb6Jc3KGhdYsTizfNMpAIIrNPRFaaBk2R+yigow9MZxFzJpkmMWl2Imr0Tmy1dBhjX9QiB7Yn6cqhFcF2goWR2rjw6FQCObv4SiinyNdAZoqhDiRb1qiR7pGq/DjwW9VOjWtI6+JUaNscdXg2xoTB/LQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1674215749; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=X9v8lKIda7JX0Bhuow6Phl/DazmklbBMXaY9S6j72KI=; 
        b=XMFZjGj4kuuckhl4VohRtG8j1BADQH/CSDixbJCWJKYGfIr1eF6VicCmpvTtO1Hb4pXD8y1pij6GTTdjAmP1+oE1/2d+gtbHtl8Za96G0TTRgDYO2qcwM7akuy7460j5LEuxWLazqDlB/PqDCS44gbVvSnES+Wj5GLwZeOxoEH4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1674215749;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:To:To:Cc:Cc:From:From:Subject:Subject:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=X9v8lKIda7JX0Bhuow6Phl/DazmklbBMXaY9S6j72KI=;
        b=CS6UY3Aw0Z6vJJNR/al0T4xSXxhS5vl0UEzQzuGd85lu1kHvxgBj20gwoUHDxOm3
        0I9hhUUdFyWJAPP6Qawh4RaPjTV/cY+uBddUvE2iwZH9EwIL8CJ0Li7IIhs62BsHioI
        rE1z1R1AHcehq6CH/0f13bcNXZYkGUaw4T5yc6SQ=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1674215747000432.4006901296883; Fri, 20 Jan 2023 03:55:47 -0800 (PST)
Message-ID: <ca79114b-abb8-fd2a-4e77-36e23dbec0f4@arinc9.com>
Date:   Fri, 20 Jan 2023 14:55:44 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: en-US
To:     stable@vger.kernel.org
Cc:     Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        erkin.bozoglu@xeront.com
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Please apply ce835dbd04d7 to 5.15
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit ce835dbd04d7b24f9fd50d9a9c59be46304aaa8a ("staging: mt7621-dts: 
change some node hex addresses to lower case") upstream.

Please apply this commit to 5.15. It solves the regression the kernel 
test robot has reported.

https://lore.kernel.org/all/aa73cfb8-99ed-20b4-071c-9858399aee0a@arinc9.com/T/

Arınç
