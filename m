Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07DD74D80CC
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238985AbiCNLeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238976AbiCNLeu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:34:50 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75873E0E6;
        Mon, 14 Mar 2022 04:33:40 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id lj8-20020a17090b344800b001bfaa46bca3so13986836pjb.2;
        Mon, 14 Mar 2022 04:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rxW8OLV5d60dDbim/dUwb9rNzRVo7FQCDOFB+aWV7eg=;
        b=QoRMqnitnVM14BHaQtaI2c20aX26T1RAomxWsNHNQJw0abCypxhyc7NFpRiASbFGg4
         zysZOlgn8zfU+ljGcCN7RfGy2fX7ldH1ptlZXySk20MAILTHIQmbe0CtOUSOvPZJRdDw
         GejNNS4eZAV7uDDMIm9kKg3ONZ5UymMYraDO6Sf8aeby3v7bEy9EoZo83FASZXJxOM4e
         O86ysF1so4eFsA99A2OMWV3UjY0N6+PlSUqZYnA5a9JOVi4npertAwY8egTIH+IoeSGK
         EdEH55z+aTprUA0qWA/3XvYkjzsjK9chsEEiFBzMJE/3Zlcv6Un2yG72xCjtPSqaRBK5
         GzXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rxW8OLV5d60dDbim/dUwb9rNzRVo7FQCDOFB+aWV7eg=;
        b=6viTcevrZ6jnUaDScHzW2ntzTIZbcGfDFwEbD1PLJaztEgwNNc+6fH3MqZVSDwlaP/
         C85AUJLRjGh+LXt/SMIU03zexMqrJ5pWIw1qpQal0F1Eh/JxW4GAbBN3oALMIuzVFfS2
         oLK0sIwld7T1CuEoYZ4IgKgB/K0PUZHrvQsd7I45//12ImT7Q1xDR6/fwlqxrRBOWysw
         +Sap6SDrmG7tTCKeVNuMItwlIqn6A3fFS69c/09zb9iGJPReJ4N4GEJZQusSiRkIjn5N
         8cbsT8hgMPNbgMCHEWKtJrH319iu0/5UBsJYwISEuJ/3dGaTqkIQl5V9vSG/sm7oUqwG
         rZCQ==
X-Gm-Message-State: AOAM533j2iEE6RjGDVHBTrY6JCZL7FaKUfaz01Rg2dBaVc3vTqvZXG3l
        GqRa5xdQmaCVln+BHN/SgZ3jC1tQmxrRYg==
X-Google-Smtp-Source: ABdhPJytWK1z7s2L76wA6jYHZDUaYM6dcVhGfK2yPMIuO7aFw3Q5zDsTDK+dllJSllDghb8rOD+f5w==
X-Received: by 2002:a17:90b:1c88:b0:1b8:a77e:c9cb with SMTP id oo8-20020a17090b1c8800b001b8a77ec9cbmr35970237pjb.205.1647257620081;
        Mon, 14 Mar 2022 04:33:40 -0700 (PDT)
Received: from ubuntu.mate (subs02-180-214-232-74.three.co.id. [180.214.232.74])
        by smtp.gmail.com with ESMTPSA id 3-20020a17090a030300b001c17851b6a1sm13608117pje.28.2022.03.14.04.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 04:33:39 -0700 (PDT)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/5] Documentation: add note block surrounding security patch note
Date:   Mon, 14 Mar 2022 18:33:25 +0700
Message-Id: <20220314113329.485372-2-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314113329.485372-1-bagasdotme@gmail.com>
References: <20220314113329.485372-1-bagasdotme@gmail.com>
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

Security patches have different handling than rest of patches for
review.

Enclose note paragraph about such patches in `.. note::` block.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/process/stable-kernel-rules.rst | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/process/stable-kernel-rules.rst b/Documentation/process/stable-kernel-rules.rst
index 003c865e9c2..691d7052546 100644
--- a/Documentation/process/stable-kernel-rules.rst
+++ b/Documentation/process/stable-kernel-rules.rst
@@ -35,7 +35,9 @@ Rules on what kind of patches are accepted, and which ones are not, into the
 Procedure for submitting patches to the -stable tree
 ----------------------------------------------------
 
- - Security patches should not be handled (solely) by the -stable review
+.. note::
+
+   Security patches should not be handled (solely) by the -stable review
    process but should follow the procedures in
    :ref:`Documentation/admin-guide/security-bugs.rst <securitybugs>`.
 
-- 
An old man doll... just what I always wanted! - Clara

