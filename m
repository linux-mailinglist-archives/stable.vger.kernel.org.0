Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 917F069C0F9
	for <lists+stable@lfdr.de>; Sun, 19 Feb 2023 15:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbjBSOqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Feb 2023 09:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbjBSOqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Feb 2023 09:46:31 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517EA10C0
        for <stable@vger.kernel.org>; Sun, 19 Feb 2023 06:46:30 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id br16so856779lfb.2
        for <stable@vger.kernel.org>; Sun, 19 Feb 2023 06:46:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J5dP96msn5OEfoRncxfnmspfuOu7WRL9ziQXWSWv0v0=;
        b=ViMVSujwy6VU8N5dqomPDsmQz6Mbhw/IvOAw1HRQZIMXz8jH9k09tkH/ixY9GVAFxB
         5Z8EOlgNBgArf2G0T0foamx2Mm5aoOty1bfkjC6ya2E8RDtvooF5/SIJjT9BCc53qqpa
         zAVMw6fGay9UD3yNTdQgS37Mrbr1PCFFCcfdJs8S0sOwAEACxzBEgguLVmYRW1YBmfEL
         jcFfTtb15dNB9VPexbOO6Vqljt5VQX15Pf5IZVdDrgXfclzaMoZ9KxAl2+vRIVAhFmTh
         p3B5MUFjVaGledBlDE3RF9FTGDqoC2NvEEydDqtL1z46/QvzMxD3F+p7CEUD9lT70aS0
         jZ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J5dP96msn5OEfoRncxfnmspfuOu7WRL9ziQXWSWv0v0=;
        b=xG1ZKn8shyg1msED+RQEO2JIUYYmuqRd92TSDop6wkah/L9DUSmEwHVzOVv79JHShF
         Ldw4PlxTgagkWWFGyuQnfwTrVBFgP8kil8jqIG633DjUny7PcdmZmsAmE2Fmch9dc9au
         mL7sLDjC89L6VIpJVkPLACnl6G66/kq04bsyEQE5lntAOj/zvD0j0Y6XJzYzRhtgWQMA
         opRLTMl1iSFIHfhw0syFcxqPcvhiedKuWO0QL0EpqboxCJVoQK2Gn9xhHdo2aK1JFCbe
         y2yq1liwFB1irfVrTLsEYNSkywOSmJzzCqeA1i1zzlJdaualakg6MJI8gGA5qay4cYUB
         Tb0g==
X-Gm-Message-State: AO0yUKX3U7YSYul3CfJ1jSIzaL3RHMJBQyq8XT/8dWPlyGfQyMZDhQaV
        xUgTEwwJQ+irc+ccDftDzd2HyyLgSo1EoZawLAo=
X-Google-Smtp-Source: AK7set/Aa+29uMGnJyzMV5m3/2St5uWA944IBRypwaOw1jxG7DAOC41p6pjw1LbaoULi7fPEdG8l0iom4x5IE3Jx3VI=
X-Received: by 2002:ac2:558a:0:b0:4d5:ca32:68a3 with SMTP id
 v10-20020ac2558a000000b004d5ca3268a3mr491261lfg.8.1676817988512; Sun, 19 Feb
 2023 06:46:28 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a2e:bc15:0:0:0:0:0 with HTTP; Sun, 19 Feb 2023 06:46:27
 -0800 (PST)
Reply-To: a12bello@yahoo.com
From:   audu bello <u206ra@gmail.com>
Date:   Sun, 19 Feb 2023 15:46:27 +0100
Message-ID: <CAN2c+rW+9NXLCp95YgCQ6to7aC4Bq4QhE0j9E51Kr0Czi3rS_Q@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.5 required=5.0 tests=BAYES_99,BAYES_999,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:130 listed in]
        [list.dnswl.org]
        *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [u206ra[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Would you kindly talk with me about the pending transfer?
