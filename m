Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97B74C795D
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 20:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiB1T7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 14:59:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiB1T7m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 14:59:42 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1EDD31DFB
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 11:59:03 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id vz16so27176649ejb.0
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 11:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=kMFmAvHoAKKkiQ1f57Jq6yU7a1iO5tuTpJwDfWZVr9I=;
        b=JEQHJQPyLp/dB+FdsNChTBytzX1TL+U6rgJJ3nQTfugYlH6ap21WN+NC0WFhpb356M
         ez9SXThMrDkY6qDEXlKgKT2O5nwI1gui/vR5smuqmM956wStF3WHQAKjQeC0dPuSM6ph
         koz9jk6irkkxcHW6kR6GvWKl2RODcGtI5BdLj0j4/u7tlGlpPtZN0cQhVgm4XU5e4ZTp
         PclpjqDWMXS5MAKN5OftySsiRO8lJ3pQ9zuudJViGmplQyFYymt9VnVlQ2aYhiDV3plm
         R+AjiFKkJdvg7/RAoIpIpvYEj4bboYvqrPoYTEniZH3MrlNsfpp2Wc/VCxqC7dUEWXot
         IkJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=kMFmAvHoAKKkiQ1f57Jq6yU7a1iO5tuTpJwDfWZVr9I=;
        b=mkzGIK40o0riRBok/IHNIQM5JaP00tjBAVhGtkkocUvyfqZAC6IYBnjIIwtIXqN0w5
         oNR0tHg8O8gevlgl03FzQk76xXenE55Zl1RyFJwjjCH7AqnyvdgZOMZgWYB6HjUt7t02
         4VdpSgiHMMe625RMNypJwevBmsT1DJq8E2Czga8llnZyrG/qe9WR/uKgPRRTYeHPFpuI
         KjvC0e+mTPHxkqT9Eg0E2ZrUnTLlO78WCAIOyGn+gT9ecZx2H6KDBqviDj8Rt9sag6zf
         DamZgH2DxJMlImNLAtVdr2UN7LBw1IHB25sSv/8kvhNn8W9AtifGAL3APLJnnO0UUVLU
         DoQA==
X-Gm-Message-State: AOAM533IShGtt8isgU0DXQ/WvXROXukFhgbj/pwIMcbQFE311Bd7HSta
        yfTM6D/8JPrMDFe+k0bX85Bm8CP2rh3Szxo71VE=
X-Google-Smtp-Source: ABdhPJzMEcA3EkFU+Ov36X4iB8H1okmfYzrUqbnBrS9QBugndT4cVtK1Ku3s8Vl1fUthwHT5Ue/SOwtLsXX7iSQybvk=
X-Received: by 2002:a17:907:c92:b0:6b5:c8ae:7918 with SMTP id
 gi18-20020a1709070c9200b006b5c8ae7918mr15791062ejc.531.1646078342277; Mon, 28
 Feb 2022 11:59:02 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:906:3ad6:0:0:0:0 with HTTP; Mon, 28 Feb 2022 11:59:01
 -0800 (PST)
Reply-To: anwarialima@gmail.com
From:   Alima Anwari <khuntamar5@gmail.com>
Date:   Mon, 28 Feb 2022 19:59:01 +0000
Message-ID: <CAOdLAAKpBjOZC0WthO29zga2hypn8_FAR5VeH_0Jg=Ge8AhE3g@mail.gmail.com>
Subject: =?UTF-8?B?44GT44KT44Gr44Gh44Gv?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: Yes, score=5.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:62b listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5001]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [khuntamar5[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [khuntamar5[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

LS0gDQropqrmhJvjgarjgovlj4vkurrjgIHjgZPjgpPjgavjgaHjga/jgILjgqLjg5Xjgqzjg4vj
grnjgr/jg7Pjga7jgqLjg6rjg57jg7vjgqLjg7Pjg6/jg6rjgafjgZnjgILov5Tkv6HjgZfjgabj
gY/jgaDjgZXjgYTjgIINCuengeOBq+aIu+OBo+OBpuOAgeOBguOBquOBn+OBqOWFseacieOBmeOC
i+e3iuaApeOBruWVj+mhjOOBjOOBguOCiuOBvuOBmeOAgiDjgYrlvoXjgaHjgZfjgabjgYrjgorj
gb7jgZkNCuOBguOBquOBn+OBruW/nOetlOOBruOBn+OCgeOBq+OAgg0K44GC44KK44GM44Go44GG
44CCDQrjgqLjg6rjg57jgIINCg==
