Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD1F69322D
	for <lists+stable@lfdr.de>; Sat, 11 Feb 2023 16:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjBKP4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Feb 2023 10:56:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBKP4B (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Feb 2023 10:56:01 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829112940A
        for <stable@vger.kernel.org>; Sat, 11 Feb 2023 07:56:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1676130953; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=DB5KqwhWEeWWajO0e/sHel2pyKsa6z8H9v4FEDRQlTgn9WA27pzTrlJRUB+ZgbNlUnBPHiQyXKrR3/8h8DE9GpldTUBCw+kXJgM5E9Z/wInf0upLPLOW5xq8Ry8p4mEIirNaT6Wr9HAhTAFknQADU0DiumsfXXlOZR4VaR511gY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1676130953; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=XRPoRxs9D8k5ekRHFAI58WTGroI9XBCXgP9PydIsuDM=; 
        b=eHvW2sOgTDYNNfa9b6NPFo84ZwHhNm4+LsYp50A0ZSgm2mVbAX42G8xIO+u5LFju5cxMiegJ6HpdoOlZn0WsUPmfS1k08s1aVlRNNBph9OvOIHUDvxADwb1yU/Gh53Ig0qTmwVS0dW/1TmIeDWJ7emvFWFAT83FZACOhkzfBN0I=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1676130953;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:To:To:Cc:Cc:From:From:Subject:Subject:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=XRPoRxs9D8k5ekRHFAI58WTGroI9XBCXgP9PydIsuDM=;
        b=X1wJVQjtDXfk7YAnmm1Xqhhttj6+6PiuIK33GpymzSdyW7k2CxVX1LvLPlkDa1XD
        Uli5ai2Bs0NB5/BO95SotiflPM1DLmL3w1XRm0NXOdlQqFBGhiiLA20KO2seslJuDEl
        yXg6XWSkTni+Nm6w/eQ1AUJSYuvg8g3nMnvFN2v0=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1676130950886409.4128304243701; Sat, 11 Feb 2023 07:55:50 -0800 (PST)
Message-ID: <f260225d-2a03-8d41-58d8-da278a790a95@arinc9.com>
Date:   Sat, 11 Feb 2023 18:55:48 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     stable@vger.kernel.org
Cc:     Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        erkin.bozoglu@xeront.com
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Please apply efbc7bd90f60 to 5.15
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

commit efbc7bd90f60c71b8e786ee767952bc22fc3666d upstream.

Please apply ("staging: mt7621-dts: change palmbus address to lower 
case") to 5.15. It solves the duplicate label error caused by the node 
name being uppercase on gbpc1.dts, but lowercase on mt7621.dtsi.

drivers/staging/mt7621-dts/gbpc1.dts:22.28-26.4: ERROR 
(duplicate_label): /palmbus@1E000000: Duplicate label 'palmbus' on 
/palmbus@1E000000 and /palmbus@1e000000
ERROR: Input tree has errors, aborting (use -f to force output)

Arınç
