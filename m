Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A17DF4B3C83
	for <lists+stable@lfdr.de>; Sun, 13 Feb 2022 18:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbiBMR0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Feb 2022 12:26:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233208AbiBMR0Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Feb 2022 12:26:25 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DEBE2F7
        for <stable@vger.kernel.org>; Sun, 13 Feb 2022 09:26:19 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id f6so4309047pfj.11
        for <stable@vger.kernel.org>; Sun, 13 Feb 2022 09:26:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=NAOTnSqBVrMsoViwE2ujvhTNQeAIBbo8w8ntVRRI7YE=;
        b=aP1oMUAKm0nQjsTqIzzKbRyNgue3sq93u16zLWoOxJIjcO+cFCykS9kkZWGMoUL6nL
         rz03n29MqhWWwlwmWp6MaaPu1LyIJ5d5L8588uke1Q2Q11kNb0zeU8u5z5Jwbg5gfz2E
         Vpy/r9ADibp5eTbntzUwSbwWggSjnd75/qSvVUenx6h86SvbV+4x/ezVTUQ3N5rW60dY
         lTw7t3/9xJvUwvfuRqrkEnPi5dWBRSCKv9Gq+4QNr/RRP/UvcIPbFg1MedJuvEBwBJ2x
         6xquCc13Xa3WA72EJWYygHb+iAcFDNbnwneEuiGFVwM47qK9PQvWFYF6wCTE+SbkSmUZ
         7ndg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=NAOTnSqBVrMsoViwE2ujvhTNQeAIBbo8w8ntVRRI7YE=;
        b=JpjDKEZpeWnE3SNZkYnZSjAuT7xZoXNPYdebo0RnLlZPv1PilykzYw+i4i0/llhd78
         lyRYStFAdP2B1lX0iKta8kEA8TPWtIrGSGds4q0w14G57XaXriJCenGayJKveEnhSjQD
         8ZXYjQkT2uocCCXhffUh2hr6XAiuz+cinAWB7ogt7M21taUA2cTMcGTIo7SROvsHHWjG
         JRw09TTVvd/7Rxd+oUrWYTY2ScA/KPlpcEqBI4gXOZUVpGswcbK0V5HyzTdn2X3wdJ0O
         sjC+yrvRnLksq5DYk/SFhDvgTfd5eEwGNVWBEnAEjwHSuNClNT9t69G6QAkDuId3jYTw
         dPHA==
X-Gm-Message-State: AOAM531n9Ja/aqltU11wvD+0tuBKWFQCyNI/KcY+hWsF/1nwmwg9acWu
        JsXk8cfx3LdGWMilkzO0Y6JvdYDoLgo=
X-Google-Smtp-Source: ABdhPJydgtgVmkPsZ+wpVc2osfw3ytPTRRAWetT1ykVBQ1E4cmIUO4ZKC1Ue+eQ6zQuActF15tVTWw==
X-Received: by 2002:a05:6a00:2281:: with SMTP id f1mr2774645pfe.34.1644773178331;
        Sun, 13 Feb 2022 09:26:18 -0800 (PST)
Received: from [192.168.1.26] (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id m21sm34343328pfk.26.2022.02.13.09.26.17
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Feb 2022 09:26:18 -0800 (PST)
Message-ID: <9d661b63-5640-fe88-b938-1f4d1767908c@gmail.com>
Date:   Sun, 13 Feb 2022 09:26:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     stable <stable@vger.kernel.org>
From:   James Smart <jsmart2021@gmail.com>
Subject: backport of lpfc patches: NVME_FC disabled and Reducing Log msgs
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'd like to request the 2 patches below to be backported to the 5.6 and 
5.12 kernels. Other stable kernels are fine. The fixes were recently 
merged into linus's tree:

scsi: lpfc: Remove NVMe support if kernel has NVME_FC disabled
This can cause device connectivity failure.
commit c80b27cfd93b


scsi: lpfc: Reduce log messages seen after firmware download
This was causing overruns and headaches on consoles that were very slow.
commit 5852ed2a6a39

They are relatively minor but have been significant enough in testing to 
be desired.

Please let me know if they can be backported and if I can help in any way.

-- james
