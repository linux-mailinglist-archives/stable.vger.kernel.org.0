Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8B49638705
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 11:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiKYKGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 05:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiKYKGD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 05:06:03 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B652227FD5
        for <stable@vger.kernel.org>; Fri, 25 Nov 2022 02:06:01 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d6so3570230pll.7
        for <stable@vger.kernel.org>; Fri, 25 Nov 2022 02:06:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=m6praLfBbS2+v6pmrTFqmzI9Vs0quL3UEZkZOQoQ1G4=;
        b=ImpJVA1ZOkuP71vPXn3QRVrmlkdweoh5MMSXujD0XjeeV196SugvptennGAxqtOtXw
         d7GsNDRR1MfMzDxaQ5faSRb6EpvqOKHVkOCxjUDQX5/uJ8WpTYd26h6/7a1B/VX+U8Xr
         OQVR0qw7C33kFk7WFveWR0IB7XhBT+PGqibXbMT96QNM/yVWYqajZYjdVyfcLeDF2KEP
         IPPxLcn/MyA55wk30SN0mziNVHzEq3CG6XQGscuaJ0gqSFyvk+ufMpy+Qo921uL6erLW
         tTsaEXALnaXYffaJrKcrmhtAECR64lrepPz+xIU2GcmezUeFouhBvyDrpNYV9Lo0Zc9V
         Yx3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m6praLfBbS2+v6pmrTFqmzI9Vs0quL3UEZkZOQoQ1G4=;
        b=X9VCOo0rz1hlVRZBybhQdSNWdeFBMbUemYaYrJyH0r5VqeOqmvNibUP9Le/y+GKetN
         VmgCiDzfoJo0EZgzl8o61UxNOKAU2CMC/CcM7PV2pxBVBh8Ng585kChUh+sKlPcHfGeY
         qVKn76t4UleJ5fkJVCHNJWQcia6YnsN9u61UIZW46lK1Mq8okZLjwS6jTsOASzjnX+sC
         L862PwK2N2pAK9kTolzfjcrsLKEvNIk3H4iJHBpU3MpclWeQICuCh6LxeGQgiXJXKIdB
         eBRqKvpafH7eeb7AnZwaXCP6YHzPW9hErsq03B22LXyAhPuvTxKaNn5XFvafYrx8VZvN
         zHHg==
X-Gm-Message-State: ANoB5plLn1r6HUq29b6Zq3aH7ZoQ7j4cVYcs+ysJF6usd87iYbd4zWRP
        tEIfS0CPOp5k5Xok0pngbo8YPzbd2EFNsHlMEBJalF6D66nT+3Dc
X-Google-Smtp-Source: AA0mqf7NmSr60u1dmaFmBU2qRnGytlIU5rIrbfX2au0fwOaPjesO9nDK19/ZT7ao84id2lJtxOyyDAETVR+i/SFdOQ8=
X-Received: by 2002:a17:902:9882:b0:188:7a1f:fb18 with SMTP id
 s2-20020a170902988200b001887a1ffb18mr18763087plp.0.1669370760989; Fri, 25 Nov
 2022 02:06:00 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:522:a604:b0:496:1699:2035 with HTTP; Fri, 25 Nov 2022
 02:06:00 -0800 (PST)
From:   Bc 10 <kubusik.berek@gmail.com>
Date:   Fri, 25 Nov 2022 12:06:00 +0200
Message-ID: <CABLWfbjcdZ4Uh3Yty7WXa7oCBVCddymPXZ8qjYbe8N-FAidS-w@mail.gmail.com>
Subject: Fw:MICROSOFT PROMOTION 2013
To:     stable <stable@vger.kernel.org>,
        stacey mcpherson <stacey.mcpherson@amaisd.org>,
        stacey tyson <stacey.tyson@morgan.edu>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SHORT_SHORTNER,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_PDS_SHORTFWD_URISHRT_FP,T_TONOM_EQ_TOLOC_SHRT_SHRTNER autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Almost all problems should depart because of this https://bit.ly/3gAQnJC
 Yours truly,MICROSOFT PROMOTION 2013
