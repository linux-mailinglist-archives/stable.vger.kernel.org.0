Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4755654B05C
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 14:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbiFNMRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 08:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357061AbiFNMPP (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 14 Jun 2022 08:15:15 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B794B7C9
        for <Stable@vger.kernel.org>; Tue, 14 Jun 2022 05:15:14 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-fe51318ccfso12285784fac.0
        for <Stable@vger.kernel.org>; Tue, 14 Jun 2022 05:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=lBFrwc11MgcaK75qf3EwNhKoIfwLYz4Dn7scEjO7Hwc=;
        b=q1ZHzXvlDj8LOEAdmBXsU7zUpu07T3NHBto1D6LA4e8nmylFsPfEQ8pBcu9tTq6ykZ
         4IzpAvMKRpIKRdA0crgk7LvKhuptb2oL/XHs7ZY3TGjOWejBJ4ja0FdmQU1n+GR80nNF
         Whl0m4k/UtNu+/UezpST0fSYUAV5lqmiMYTugfODW3AG/yDa2D4UCFS/U5yJM6Qp5gSU
         gANpJT8ZPfF4Yp2Oo/B+bN8MQpD3aiOhzuzEJ8ESIiWoiKm74lpAqWu4MEwfcoySFSYB
         FEv4j0rvJGfKQPoHsSUB8OpNVisfJ8P9KBK0eA6zH5d+KR165ZiYAaVb4y1nICJ5x5lu
         u2XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=lBFrwc11MgcaK75qf3EwNhKoIfwLYz4Dn7scEjO7Hwc=;
        b=0xp4ar7Dd8JHL4ZEtvUSPbjpfDSYJHYi+u3GoygLEHcygtQC43o/YyoMcbFs1O65b2
         C3yeZE0piJKjI2uePIhNfdPLjJ+q3Hh5PcNFvfWloxd2JnNf6SrY5S75Z8FEO7v3QyCf
         hPcp4ujuIgrVt/H7IJPITLy/vWI/Mo1BuGcp9/Ixvf+L9IKhfLR+bUCuMyOt8eAo3X4i
         IRG5hjV78Tc4HM/gZAI7hmX7xe7PXBqwJPiHg0w1WT/Mo6b6lFt45lHJoflz/yi10jHQ
         Hwy9EVePGmEcSFqHF6mFwBbVX8+v3LnViBXLW/R5T8wgKIZdMsGLcn2TDTP7csCBSwv8
         HB6A==
X-Gm-Message-State: AJIora9s5YiYCDqSAEvqBDghyIxXfXTGebLWrdxHaJtEPnxsuOMkdR2h
        aduMJ+USN5yRJZiZUU2iV/axLuS2m5GrO+3KqcE=
X-Google-Smtp-Source: AGRyM1tBbssU7Y4n/yrCYyix5VDd/V/spZdwNyrwEq15dTSKbhQgqnchFlQzzVOOa7cnZgRBz11tpm1K4CLJ2YEQDaQ=
X-Received: by 2002:a05:6870:648a:b0:f8:7602:8402 with SMTP id
 cz10-20020a056870648a00b000f876028402mr2071511oab.194.1655208913963; Tue, 14
 Jun 2022 05:15:13 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:c46:0:b0:42d:ab20:ed24 with HTTP; Tue, 14 Jun 2022
 05:15:13 -0700 (PDT)
From:   Daniel Affum <danielaffum05@gmail.com>
Date:   Tue, 14 Jun 2022 15:15:13 +0300
Message-ID: <CAPkju_Osm3rNwgZc_tEEXE7SB80wPOA4Z5-vbZd8xePue0-g9g@mail.gmail.com>
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
