Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56DBA54B080
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 14:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbiFNMZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 08:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiFNMZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 08:25:53 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875461FA70
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 05:25:50 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-fe32122311so12235120fac.7
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 05:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=lBFrwc11MgcaK75qf3EwNhKoIfwLYz4Dn7scEjO7Hwc=;
        b=qCOswa1X2iwrMMnjqzOyVd4rkA15m1eqp65wqzm4NO4dTio+nSuXRGvne6bTEQJvJZ
         jPzp4yCr877OUJ2stEApgIrH4BDmm8BDr7afuskIsxSjiYBBeWO/tCGsRmqz9H3NXdx3
         SR4veMTt5YgYczFHDZOrfB9oPbNaaZNETMHXOWSEDSDAksffJbidhccLOZrKHaV2RcT5
         oLOUA6sbAYW+ZsY7ppy/AHvmppOQLLO1QB62TekRty7MBYqZhU6Vhfx7sUdxpGCkZQo9
         /yftTlwngLgygIcVmVYfDHAWx2tRoTBnRqBgsSe/rdFBUD36HOEBh315hI4S0x1xzPEI
         LBbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=lBFrwc11MgcaK75qf3EwNhKoIfwLYz4Dn7scEjO7Hwc=;
        b=lMbnYwHdy8ZMdw/0+0ZF2n/oVelmXlvVgeURIv6xluRtzPEPLclyDrvBwFNre+nRf+
         El8738FxleS/1QJRnxUuduRFIK6UzxubIEcWwZMSSGUXdQmuMcK/JdqUmP/AVioEqX67
         MqSukNAPyUC4MwPfsb0cJ9ey/gDhU3B/yduS2QvvNvhsGZUEd/0TvOTcuJqcIqad+v5P
         bojrKZpkfBLLF72hzDGCgxQLotuCx2qEwhSKTxlgCy16VoH+CiWfN830Fnz8Bc1i6h4d
         4O1mzgsSKr890iQviAVJgMTsbfpqRLs0VjahQOjLKwx18t3S+64Xm4au4vya6GO8zJnq
         ubOg==
X-Gm-Message-State: AJIora+X72nLhYR3wEgUrjcEKBnFCjzmwIa8+aS/+a8mQ6yBEQjIoSjc
        T9FTRhOXvW0pFGsE/SvgTbzLDX1hDr06oRqm2D4=
X-Google-Smtp-Source: AGRyM1vzl0G+vQQT41RVe7M1Nw0a6gfSysIp6DQ54tjAHcLdA8SGS4Agb+XtwUPETxCCNIjKFINBAqMp7zboKfzC5ss=
X-Received: by 2002:a05:6870:d287:b0:f1:c50b:9dd1 with SMTP id
 d7-20020a056870d28700b000f1c50b9dd1mr2103525oae.45.1655209549864; Tue, 14 Jun
 2022 05:25:49 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:c46:0:b0:42d:ab20:ed24 with HTTP; Tue, 14 Jun 2022
 05:25:49 -0700 (PDT)
From:   Daniel Affum <danielaffum05@gmail.com>
Date:   Tue, 14 Jun 2022 15:25:49 +0300
Message-ID: <CAPkju_Nw-+rEaWcZEek6AtbrSikxe4tsB8-9OVibuRx7BOXGRg@mail.gmail.com>
Subject: Confirm Receipt
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Dear,

I am Daniel Affum a retired civil servant i have a  business to
discuss with you from the Eastern part of Africa aimed at agreed
percentage upon your acceptance of my hand in business and friendship.
Kindly respond to me if you are interested to partner with me for an
update.Very important.

Yours Sincerely,
Daniel Affum.
Reply to:danielaffum005@yahoo.com
