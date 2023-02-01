Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70735685DE1
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 04:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbjBADVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 22:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbjBADVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 22:21:43 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8EE30197
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 19:21:28 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id z2so6831842ilq.2
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 19:21:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:content-transfer-encoding:reply-to:to:from:date
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oK8yk8IitEw2pAqgYIsKhI9q/RDh+OTCFAF3BQhvlN0=;
        b=gYp3hgoNj7c5/FUMEYVLJDhoBrJlxnsrsvmQthu16he2CyAMhCiZKhqhz3NBnPllnA
         v/vrZ/eb4+uwLSxIq2TBu+DGaxEklNaf8836HaHca+HcJBbSWOFALXV2To56i3/5+mEa
         6FCTQAswOYUjzqEn7LzKFiCbHOqUyd+dzoGAD71AEo4V/AwDH3Sty/B/nr1zvAJaMGCY
         1cvKm6VQRNjMBWB/fKM0Ve5HAt0W49edt/dnMbVlmrRLEkm2RYASKqBytN3Uta2eqBTE
         Jtzs+X/bYcIz8ZMkfanqu7Nibot9WZHjfSc742RgpsO65DfCAl8slZcl47j0EQDS0wEY
         MTjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:subject:content-transfer-encoding:reply-to:to:from:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oK8yk8IitEw2pAqgYIsKhI9q/RDh+OTCFAF3BQhvlN0=;
        b=PpjksvyXIQLRocfdU2JpvsgklEwaID21Q2HYfzS0WStHuvK8jaU3bV56vihH8/nVgC
         qlHH9ra2BNfk6HO40qIowbQh+9HFyJoitHZhDIYijayRzHpan1My7DCKCCK4UQVeX6OE
         RK0o1qoY4NGKn43rNGdBw4pPJHgqFb5bq3CAIJ8+QkI053Tn3iD8QVjJ+BZF2frKQfXx
         KwOzqzqticm3l2ZjsZhPLbjNrQS1yFhIrvxqEPO9rLCMVmzqM5jMTB9iFOi7JRlGiwoB
         x5lHDpaZDoDCUOsB33ycXxpoR44F5tDXatwd0nvAKj6JSmh1lEYt7FdtoID6VuQ6IXqp
         Mo6w==
X-Gm-Message-State: AO0yUKW9uQWCO1iD46Bn5/H4GjHYYieHu+DC+SxmzUvvWyDqP4GRZ7ge
        /7YYCz98JVUPmOc6Pv3866yHNop62u0=
X-Google-Smtp-Source: AK7set8Hbtg5RyqJywVqyiUXdnYdv8GidX20F7T4W7rYBkvS1xbYjikDZOr/H5nMH8vrID45of71sA==
X-Received: by 2002:a05:6e02:20ec:b0:30d:bfa3:ebce with SMTP id q12-20020a056e0220ec00b0030dbfa3ebcemr573338ilv.27.1675221687576;
        Tue, 31 Jan 2023 19:21:27 -0800 (PST)
Received: from WIN-9P8L97OHU8U ([212.162.149.202])
        by smtp.gmail.com with ESMTPSA id h4-20020a92c084000000b00302632f0d20sm5344000ile.67.2023.01.31.19.21.27
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Jan 2023 19:21:27 -0800 (PST)
MIME-Version: 1.0
Date:   Tue, 31 Jan 2023 19:19:39 -0800
X-Priority: 3 (Normal)
From:   "customerfeedback@paycom.com" <judithbab6@gmail.com>
To:     stable@vger.kernel.org
Reply-To: "customerfeedback@paycom.com" <feedbackreport@paycom.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
Subject: Money Sent
Message-ID: <453C419AF854BA48FCD4CBC8EB875C227B9CB120@WIN-9P8L97OHU8U>
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Working as a personal assistant for a businessman who is establishing a =
new location of his company in your city will pay you $750 a week. You w=
ill primarily work from home, and you will receive sufficient training a=
nd training materials to improve your ability to deliver services accura=
tely and without stress. Please fill out the google application for if y=
ou are interested in working as a personal assistant part-time for $750 =
   weekly docs.google.com/forms/d/e/1FAIpQLSev9NsI0Yej9ewR2JyVf_WxNcQvBr=
EtWeNrD57fBoJpyFwNZg/viewform
