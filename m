Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C9563A60F
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 11:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiK1K1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 05:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiK1K1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 05:27:09 -0500
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C855BB9A
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 02:27:07 -0800 (PST)
Received: by mail-vk1-xa2b.google.com with SMTP id b81so5002527vkf.1
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 02:27:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c5E68Sr4LhT6Cylt6+xpmAj6iycfUFIjwiLn6lUKtfc=;
        b=lW1OkKbWpDbihykQQbYL42Bvy4wsxaJ4VnqQPrI8qamDwpWMhqd0pufuEtYFuzyYvH
         Hfhc5v9cW8WhwUBfiWV+Bz6I1B+2Yvd/DHfjT0f6VSF0jezc58Zw9pLlv5BIJz8JGb99
         AQGr7inRC4dwSaC95nZbrb4QOJgAoayA2caQXqSUXzsRtbz/TSxlq98UWZk0kzfmvCW+
         NglaBvJ0ZX+2T68Rb6ddp26EBClukA5XQQXGKfsSALAh/fd3mpO4qfqPoefatJYjhy4v
         xyjSjsJ/Rh8zIuPQFDNwhjK6DJInBrYuQ6tZFgwLqDCVfj1BVO+F0KxUabHEr/MEKAS1
         A26g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c5E68Sr4LhT6Cylt6+xpmAj6iycfUFIjwiLn6lUKtfc=;
        b=EXqSXasDEbPZVaepEoxxt5r+SlHHCS4cCVIoUpfoFhnZluJGCyzjTf1Ci0ByxHR/7i
         VGprRRh4pI609MSMwrImRRt0VNrl/jC35jdQ7VohmhLmDUuPCDUzwKLCtrdle9L0RPdz
         UoGzLc2vkwSGIp30mDMfJED2kQU3ZDWfqx3WHe4HOCUmgRwigjAz29jYRtQuglMI1R3l
         WCEdWjW1ibvCRF+enADOMycn8LoBSQskLRDzYADEkLfbqXsCGZ9acy0x36dQxycELxrZ
         2u6U0hHTKYwAefBpMrU7dEHfj9ZCaUhpqmiwOr323h8FflMEcvBbLdpq0oeJoT+LLxdP
         LiJg==
X-Gm-Message-State: ANoB5plb3nWdMXssVlpOTLQXPW8MFax9TFh67CHlF4SaQp49hrp1vhR2
        Epi1VF12V8jZL9Ix7a9/h8ImCKowqUDW0JPUcb8=
X-Google-Smtp-Source: AA0mqf79HGbCNj9b2j83cwuvRxLSsR4CeBfmHCCfobnHoq5ljrT0scql8MVOLMRPpLWuUnXsJSmMua4s1BgipR991pE=
X-Received: by 2002:ac5:cd43:0:b0:3b8:32b7:1e5d with SMTP id
 n3-20020ac5cd43000000b003b832b71e5dmr27329587vkm.11.1669631226833; Mon, 28
 Nov 2022 02:27:06 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a59:cd86:0:b0:32a:c6ce:9c22 with HTTP; Mon, 28 Nov 2022
 02:27:06 -0800 (PST)
Reply-To: hegginskate7@gmail.com
From:   Heggins Kate <hegginskate7@gmail.com>
Date:   Mon, 28 Nov 2022 10:27:06 +0000
Message-ID: <CAEAJ=VxXDAi3O31aMtK7XzpfC67NrwiT5Nxvm_HrE08_qC4iaw@mail.gmail.com>
Subject: Hallo
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hallo, ich hoffe du hast meine Nachricht erhalten.
Ich brauche schnelle Antworten

Ich danke dir sehr.
Katie
