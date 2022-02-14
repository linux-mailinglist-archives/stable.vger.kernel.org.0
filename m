Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E904B5C62
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 22:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiBNVNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 16:13:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiBNVNp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 16:13:45 -0500
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7DE1323C1
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 13:13:36 -0800 (PST)
Received: by mail-oo1-xc2a.google.com with SMTP id c7-20020a4ad207000000b002e7ab4185d2so20846018oos.6
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 13:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=4M/lE5IEY0dBEGh239/hQVbyYBLkqVkQmg0uwSINU98=;
        b=NlNB95RxxGMk/v3aw7UH1iA3OwcCHl9PjnCa81DcNGhoCO0VKBAadjtlaxUaLrENLy
         3EY9QTEIk9tOzCmB7nmDyP2U+e893dMA+2xIHxLEyCh9szHPR9DCqwPAmfyLIRlTaoIe
         mPmV2aMK9r5twl6oPqzEpaKk5s5YmienNrxzKPaloykp/UiSVWm+gy4laWAdjNTq/ndF
         vZs0QPcwtpdTViGyphf9BGBQ+4JfGxWhfbrlonIuCKABEMuEn6gCOgzFsiB0/VfNyZLp
         m20yccv9z+yJUlSV1KVzngVSHDY7xdGlHvxjFxzmmn69AcGsCLfppgIlDH1IWG1gbDXo
         TZSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=4M/lE5IEY0dBEGh239/hQVbyYBLkqVkQmg0uwSINU98=;
        b=nC50jOaQK2GIefyF+xEKl26wih1bf/Ho1174lS3qAzFk61dXEu+YC/kL4T/aMX/TJI
         8YimvWEm4OV04GjF4XYmX7pfPMCg7c758m3RCGIdb9BkW8S5fPFbjloNwNC2ZLz//b4W
         zbnKii1xBUSSHHZzB8TssviFVPd1oUVZD7ZD+N2/zt4M4k7Lz+DtH/Yclal7ZsQPq3+s
         3l32qdNg9d22V6m9OSzYAXZtyqKu1hSJ1qb03wI5MV0eRylyEPasWKxb3gTFde8DP2z1
         HpPC9qSx2F6bLGMnQ0OEeSZXkpOaS+YSgJH53Cl7Rv7DvCp/6JOeaCxLSs3OvZYSWWRb
         dbSA==
X-Gm-Message-State: AOAM5302U4CFXt48ZxWYiqEEsxlq4kP5BhdhSKF6aOzZtzvwHy1v06mW
        Zd9fn+ZSM24UWiCWqiXhnao6kH3bJEI=
X-Google-Smtp-Source: ABdhPJwgFfC1W37goJN2YWkitfpP4Ma2M99E4VHxC3rjAMwOffZShKnJJz1Z/v21zsYeZfXhwmzaIg==
X-Received: by 2002:a17:90b:17c1:b0:1b9:3c05:fe28 with SMTP id me1-20020a17090b17c100b001b93c05fe28mr95584pjb.206.1644865605468;
        Mon, 14 Feb 2022 11:06:45 -0800 (PST)
Received: from [10.69.44.239] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ck20sm13025334pjb.27.2022.02.14.11.06.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 11:06:45 -0800 (PST)
Message-ID: <6aab7d93-7791-fd8b-b0ed-6a0a2ee52472@gmail.com>
Date:   Mon, 14 Feb 2022 11:06:44 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     stable <stable@vger.kernel.org>
From:   James Smart <jsmart2021@gmail.com>
Subject: Backport Request: scsi: lpfc: Fix mailbox command failure during
 driver initialization
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

Please backport the following patch to the 5.10 and 5.15 kernels. It is 
currently in the 5.16 kernel.

scsi: lpfc: Fix mailbox command failure during driver initialization
commit	efe1dc571a5b

The error being corrected causes failure of adapter initialization and 
attachment.

-- James


