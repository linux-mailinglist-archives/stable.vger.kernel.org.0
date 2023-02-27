Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 383186A4FAB
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 00:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjB0XbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 18:31:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjB0XbX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 18:31:23 -0500
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F201CF52
        for <stable@vger.kernel.org>; Mon, 27 Feb 2023 15:31:15 -0800 (PST)
Received: by mail-vs1-xe36.google.com with SMTP id v27so14020698vsa.7
        for <stable@vger.kernel.org>; Mon, 27 Feb 2023 15:31:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oJgi4IboWDAeEB/+pYFtMZQnVuI8I/vNjiJArKeJCpg=;
        b=DFdC1xkgHNdC2KtWr4gE0KCH/SDC2Kb26BqzEwcJ8NZtJSKlwpQjG4Pz3dQ9NLH6ZI
         JiTS+nz1+3u9zVWYSrKfJzUPsT4OTWCJsIsRR4F6YhkGJGZbOHKKxxKf1N4Aq9w+ZZcC
         f37lHxOAlNVRoF+qdTlsILgEhg/AFNDAYr/WSsTqplS7Ey/4FiLeVxaxB5t8lqw6UGvk
         QKV4aV6nVlsE6hhYMrMtWPfawbS6qqK8BxsVch8nNgxL3KciL8zPSoQrwWpSOCXCOYIO
         G4laprrLQoGNaC4Ro8kb+i1/cLXxX6Q/2R5XiIUhpUAL5k7/yTXbFFwaI9OA2G4NTC7T
         ObbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oJgi4IboWDAeEB/+pYFtMZQnVuI8I/vNjiJArKeJCpg=;
        b=tdhQdEns3n6JF6Aw/EVpbKlrbktIFFG3IYoYVo8zdtV7HBYNHBDMmbc0QeVMFjm3MV
         VyqBdpW5FUHCvZ944pqti3l0u7jDxf+tQ7/cHPxjRpujpsYOJpO1rc8QW/th0dS+InnM
         HJvV0FdTwwlVkhN+8TilsGbvaZ/d3svwDO25fg1426XIvsGpdrvQ/QiFiuIjTN1wYPJN
         EadniXD4n2agMD5rES9IOdOXNbCevkrWFr7r+oye4/XfUNSEN4h9H+qigPfg7v6ieznN
         p85QpTrSlSelE6fHtRXiVT8yJqNAUL34e68L24xx6fpA8ZZjJKAwAGncATi29f7iI5m6
         edfg==
X-Gm-Message-State: AO0yUKXQhcd5lnQ404n+cJvrD2dqkOLH1QRGiIj0ey5Yk9Rqr5RzREwl
        QzE2cHKxGxRBERu4HxmiOzp7BtNtjpEOE+wqE7I=
X-Google-Smtp-Source: AK7set82V0LrcrRHCtAWOiAISYkLwIaf8EofE385QJpbmJUvCVdtcjwg+lRThqMIeFSfC+1w3sfPAtOLusgpIgXyNEo=
X-Received: by 2002:a05:6102:21d6:b0:414:4ef3:839 with SMTP id
 r22-20020a05610221d600b004144ef30839mr795857vsg.7.1677540674224; Mon, 27 Feb
 2023 15:31:14 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a59:9304:0:b0:3aa:5d69:35f0 with HTTP; Mon, 27 Feb 2023
 15:31:13 -0800 (PST)
Reply-To: Advocate@tptlegalfirm.com
From:   Larry Aaron Riteman <gdenzell428@gmail.com>
Date:   Mon, 27 Feb 2023 23:31:13 +0000
Message-ID: <CAP7AjhcLUMc1Fud1nHpkRezgi7UP1zZT0ytCLAYG7QdAnTOj+g@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.8 required=5.0 tests=BAYES_99,BAYES_999,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello.

This is my second message to you regarding the estate of your late
relative. Please contact me via my email ASAP, for more details.

Regards,

Larry.
