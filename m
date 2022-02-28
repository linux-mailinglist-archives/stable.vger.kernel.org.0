Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4C14C63C8
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 08:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbiB1H1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 02:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233625AbiB1H1o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 02:27:44 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3398266AC7
        for <stable@vger.kernel.org>; Sun, 27 Feb 2022 23:27:06 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id z11so1558141pla.7
        for <stable@vger.kernel.org>; Sun, 27 Feb 2022 23:27:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:from:to:subject
         :content-transfer-encoding;
        bh=QCO1/HEd7WRwUqwTXMKOXf4ebpkv4RyC7DMyuYkxZzY=;
        b=DTFQKSJSTbt0RitNlc7b4I55ImnP18ZruRVtfgwO0RM6tdkyztePMMLUDxa7w4l4C4
         QPL0wUTncS8PLB9ccUZJDkWUITawuCmGTNu5d7Qjzas+pcSlAbRQC7506UB5tkorWv1u
         yy98XY0aR6XMvLGi5Bwvnx2aJH3ykYBGQFdJUc26TdbrQQil/uPgiFZvU8uuMMynY5cS
         yezM8HfJNvRB6XJLrq28Uajup1pW1/q/zUUc4d0vUvqSb6b/x42oT4rerBoMkZlydKzS
         cXx5ewIfGBjOlh4ugDrsTsppKnwWT9nlZiOBBVUpaM4CKeEj5kizGHwWYWkGd1wejAJF
         wtIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:from:to:subject
         :content-transfer-encoding;
        bh=QCO1/HEd7WRwUqwTXMKOXf4ebpkv4RyC7DMyuYkxZzY=;
        b=Um5aX66OMd+FaoEPM1KiTzWMS2lj1p+HLQXpKAFM5XWsHY2DaYO1kee30hqSIdI15A
         gttnjwY4BbjZeBP8wCOou1l+Tz1jHRW8UFbQ9KU5B2wlPTAJ5NizHYCqGLQoeUyOZjYh
         BYPuRieqmE+9CQ62dTRhac5QLulaccoDPVwh77TtHjFUCO+FVtNT79rJWBfG7SfD1ctr
         Ie5f9T7yV+EdoAF5O7ekOjqofQ55Iga7yThVgWImgcjSVPG4yUOwfkf8frlW1j+7c93S
         dccq/sXoszJOpfl2mZr3Mm7sfqkUOpJcXAjBJuSN5PVNQreU6IN83mvdtUJH5Y9V/Qye
         Se4Q==
X-Gm-Message-State: AOAM531U+2J/QOGAKV+Cv3fIBK0IDlKqZYMEZvJwUv7lZBugzfRG1OLh
        XAVR04JFZzv0OrFWIsRG0Slw3Hp2Xj0=
X-Google-Smtp-Source: ABdhPJz5DXAMflpvoafjbsA0FdmygoFNmI0Fd1kAnolV36LG9KqGw+kU1p6N4oAnJcZdNiM2XM0LVQ==
X-Received: by 2002:a17:90b:1e4b:b0:1bd:4c83:56a7 with SMTP id pi11-20020a17090b1e4b00b001bd4c8356a7mr3999071pjb.109.1646033225615;
        Sun, 27 Feb 2022 23:27:05 -0800 (PST)
Received: from rsnbd ([103.108.60.143])
        by smtp.gmail.com with ESMTPSA id g1-20020a056a000b8100b004f111c21535sm12640628pfj.80.2022.02.27.23.27.04
        for <stable@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Sun, 27 Feb 2022 23:27:05 -0800 (PST)
Message-ID: <621c7949.1c69fb81.8ba68.fe08@mx.google.com>
Date:   Sun, 27 Feb 2022 23:27:05 -0800 (PST)
X-Google-Original-Date: 28 Feb 2022 13:26:57 +0600
MIME-Version: 1.0
From:   "Nancy Brown " <nancy2w3@gmail.com>
To:     stable@vger.kernel.org
Subject: looking for something?
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_NONE,SCC_BODY_URI_ONLY,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLACK autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VGFrZSBhcyB5b3Ugd2lzaApEaXJlY3QgQ29udGFjdCB3d3cub2ZmZXIydS54eXo=

