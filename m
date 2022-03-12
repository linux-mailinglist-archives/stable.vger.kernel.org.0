Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2EA4D6D5B
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 09:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbiCLICF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 03:02:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbiCLICE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 03:02:04 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951BA1C60CE;
        Sat, 12 Mar 2022 00:00:59 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id c11so9348065pgu.11;
        Sat, 12 Mar 2022 00:00:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pz807mPXL9wmAOsZik9uq5miIUnAKaI7W2BvkwtKBhw=;
        b=CDlX98WpFMvMUJQXbIQMsrF/8YCY16xZsoQRbDtI/ZTetdXoMX4tM8lCVX+injymgF
         9eiPveWl8yE/o0AThp2w3cWm7nDCMFMMgxNprFiMgLobrwNbXep4gK9W1h4rUL0eo+7R
         Tgk0bN3PG6+4qrD9+UM8dNqyRnWA2AsFYiTw+CyA7yxOV8seAXRNra4AQAW/D6Z28KN6
         vPt+9jX5C/qBgsnsFVgiNl1NGGJlB/HLeKKp/Q+iiw5BWv3RqtWw/dSp76+Gg0cYRgw+
         r4avuWZXqA9OFUU19idwrPOotQ5Cr4xYQ1aH+w+zvRSWVcHHswHl1OAJt2OhQtQ8tx8I
         hdkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pz807mPXL9wmAOsZik9uq5miIUnAKaI7W2BvkwtKBhw=;
        b=oyoLkTfzdV5wLzXL1iW0lxsyGSbYAnYq5Qd05B/iN52zmtcSOw/U46k9dAFpFRQTGa
         8bWQhYc2KDlc1985xk3eNZTdEIpsABw99cw6ZO+t0ZUDxOpamhnY/CWh82h7HaSULFxe
         RhB5PU6pl5PlC7Zs6QYLnU45ZXOc6QUnPVwBqJT1OJUO0yi/pnTS18+zJomfRRcLcHU8
         awaARmaMHLCoNgl1J7Ok/I/8gPzB6YunhIRzSM3dgG0t434Lo4SO8cm1uPVEbPbBCAjq
         I+YxIhIR9UIVIHELSQTYKwlkh0pB+3+Zu+HgzpOj21dfxnXedOStxHBcsAmt2bcajadN
         9jtw==
X-Gm-Message-State: AOAM533O1OO2G/TIewQ2wGtQujDJZlOnFFGm2cV8xWqBLJpm8ek/bbq0
        rezqPTLzxjDmQSylHmJhsrLoVuY0maRhUw==
X-Google-Smtp-Source: ABdhPJxwpB0uaAFH91wsxCSokGUcPouvlPPxxlPVpb8sn2MIGYwfHB4yDzT7bJHogOb0EojAVsaCCg==
X-Received: by 2002:a65:6246:0:b0:363:396a:a00f with SMTP id q6-20020a656246000000b00363396aa00fmr11413522pgv.28.1647072058704;
        Sat, 12 Mar 2022 00:00:58 -0800 (PST)
Received: from ubuntu.mate (subs02-180-214-232-88.three.co.id. [180.214.232.88])
        by smtp.gmail.com with ESMTPSA id x33-20020a056a0018a100b004f71b6a8698sm13025141pfh.169.2022.03.12.00.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Mar 2022 00:00:57 -0800 (PST)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Stable kernel release process update
Date:   Sat, 12 Mar 2022 15:00:39 +0700
Message-Id: <20220312080043.37581-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The stable release process documented in stable-kernel-rules.rst needs
to be updated to reflect current procedure.

Patch 1 is merely reorganizing three submission option lists to be
subsection of the procedure section.

Patch 2 contains the actual process documentation update.

Patch 3 and 4 updates "Tree" section by adding stable -rc tree link and
correcting link for stable tree, respectively.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Bagas Sanjaya (4):
  Documentation: make option lists subsection of "Procedure for
    submitting patches to the -stable tree" in stable-kernel-rules.rst
  Documentation: update stable review cycle documentation
  Documentation: add link to stable release candidate tree
  Documentation: update stable tree link

 Documentation/process/stable-kernel-rules.rst | 31 ++++++++++++++-----
 1 file changed, 24 insertions(+), 7 deletions(-)


base-commit: ffb217a13a2eaf6d5bd974fc83036a53ca69f1e2
-- 
An old man doll... just what I always wanted! - Clara

