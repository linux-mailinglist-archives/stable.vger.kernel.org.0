Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 149D665B33D
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 15:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbjABONX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 09:13:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbjABONX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 09:13:23 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F396583
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 06:13:20 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id l1so1386855qkg.11
        for <stable@vger.kernel.org>; Mon, 02 Jan 2023 06:13:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TvGaEzKDYpz5WOFqgAQMQ2biKUT+ROlayTFkwYu4cBY=;
        b=SF2LWc8DreUIKweVAIlmhb5DeHCJrtjPC9YQ8z07IoNlhrzkV9hKfxJgZtw+16Rl9w
         D6i/yxoIMoZtY5v/oqrNWdPcEIxEAvrfU0Z5eAj6oS+rJY1ah8L9jRtB4CvIflWQLh+O
         6suVAk0cAx3QqnzDlNPnLrB3rHkKCcZEjdUMhFtXvtKbSdtLaCUZP2oHkQylspZGEBTH
         TjoSL/PBYwVOjcQE4J8iKQEnxTiF3HYnOpznAfy8VYw0hVLDGqf5xq1gjWi/Ft2v8KuE
         Y57HhUidBSZBIyMFhuw/goxM5gb9l7KCbzp9YYJ2MKlfygA5huEHUwsp4qh3iep9XNY1
         3YAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TvGaEzKDYpz5WOFqgAQMQ2biKUT+ROlayTFkwYu4cBY=;
        b=XASSr1llDNjWs1bTK0AgjIBuO/sk8jUVqk/jKHEYERMf16wo6IStn3zneOhkYhPC9z
         6U2zix4JJKMizAyJK1IIL9htT8ZMsBY8nyEdr37/wvhDnfb+ZdsGooFfnuN+Dd9AoraJ
         YpthUbkpWWW60blbikktLp9ggx5iLzmmNtTijtUq2kKz9Kwth1B9C5xgGj16NyK8a/Il
         MRj0kGmdwKXqYZMOVcZJgfKg8vy/hhQ6IsbVSHVvFoswoWzvOXNhE5SKxbcEG2diPBGB
         YI7D7PDGdThBQpGPMZIxvAOxPxEaHzTnWVCmQkPqr25KIt7Q1tbsPqykozCg0PqxZqVJ
         KASA==
X-Gm-Message-State: AFqh2ko97qNE4GpmNLro1y6tLq4SuSmEfzf0nFapxnLxTzsIpMf3mgi9
        E6vYjb2IDtKm/KrQTP8HixEOjYFS+B4ZRI+ZhSQ=
X-Google-Smtp-Source: AMrXdXvskipTQ5RG2h8bm61hVlIt5DcEIjhCCzoq6PDPCqa4PypfLrr3cEu3SUa8qUrX7DHyn7a2Nxv8drLdT0ve8A8=
X-Received: by 2002:a05:620a:1494:b0:702:14ee:7fda with SMTP id
 w20-20020a05620a149400b0070214ee7fdamr2534422qkj.24.1672668800073; Mon, 02
 Jan 2023 06:13:20 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:622a:389:b0:3ab:7b95:29f5 with HTTP; Mon, 2 Jan 2023
 06:13:19 -0800 (PST)
Reply-To: te463602@gmail.com
From:   Confianzay Rentabilidad <confianzayrentabilidad@gmail.com>
Date:   Mon, 2 Jan 2023 06:13:19 -0800
Message-ID: <CANrrfX5Hrfmi-KsLikeShVSXEDRfZxEZ_czczW-OqvLN1rGECw@mail.gmail.com>
Subject: Season Greetings,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hello,
I tried e-mailing you more than twice but my email bounced back
failure, Note this, soonest you receive this email revert to me before
I deliver the message it's importunate, pressing, crucial. Await your
response.

Best regards
Confianzay Rentabilidad
