Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF88D56BA
	for <lists+stable@lfdr.de>; Sun, 13 Oct 2019 18:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbfJMQEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Oct 2019 12:04:21 -0400
Received: from mail-lf1-f42.google.com ([209.85.167.42]:39184 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbfJMQEV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Oct 2019 12:04:21 -0400
Received: by mail-lf1-f42.google.com with SMTP id 72so10126220lfh.6;
        Sun, 13 Oct 2019 09:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=zK6MqX6awnsKT7h/tz4aHU7zt4FnJHX3hmpDCllT6Qw=;
        b=DQVT+xwVXNkS8BcdFwj+B3rQ5myl1sGpj7Ey3kqz10L8eM2ZplADf0Ie1kAr8AYD4B
         iesKdYPQILt49OqKHwk8CPhH7yiNUTvLeIaJAf/N4Uo5X9h3jyPsQWeJJSoQsRabR0pU
         HRAfXUzdvrS1PNTG2YHwbkwalMjNDHgpe2A5jLTD8pexL0SQqUoLZY07tNVFYyAxgBB8
         oJLZSFv59MzwPlJrmDkqPf8CwK3MF81bKB+4wHQImNlmq7jNjBW6rHVTJBb3hfwrmz8s
         yh1rK05n1M7fFHew0ZiOwhXGxjjplMLYU3YfUuHHahktTlEV74MtpEezKlbLMvqtr8re
         n4pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=zK6MqX6awnsKT7h/tz4aHU7zt4FnJHX3hmpDCllT6Qw=;
        b=sL4xb2MjaMER+/LGnNL+oeZgze0JPVznKzRLvoAy/QJtX1mpNRxbo2BkmmnCl0MpMP
         bVZkxI+pBnVjiQosCFAs0uzZlmBeO46TYXHLiLfwCKwNI1Qit1WfTCCwXuOPdyYMO+ha
         XGil0i/HIp2gJ4Abi2AqP10EiOpN30z3N7MsXUEWJZ3qCRl7vZG0DEdP3UHz0coLxpiR
         dnre2qXhW1hIIPHUe3cTUnWdbRY4+bTc2YtyV/FfynUuCSG5rI57V9QW0W6NQVSpNYsS
         WwJp3gYcLYJbC9X8yLrhUb/dv1Ml/Mxz27axIjav55hlzwxg4URdoWCwwNuoulBrPM+q
         CgCg==
X-Gm-Message-State: APjAAAVd2uzlDIbvU40z0eEeFBEGFFrQxvzo6t/o22A8JFdrN6LtBsX5
        B1da8tqXCF1IfSvaYJtgb4U2vYHOo5sFIGIAhgV1HzSQM3Y=
X-Google-Smtp-Source: APXvYqzHMTIEIS4nmMsvZMMjqLm0FoWqMVdZH+80rMlvYaJmaw4RAZSsrMi38lQGZITbHK3Rn3e5SvNazId2jpSY2gI=
X-Received: by 2002:ac2:5595:: with SMTP id v21mr2646279lfg.168.1570982658932;
 Sun, 13 Oct 2019 09:04:18 -0700 (PDT)
MIME-Version: 1.0
From:   Andrew Macks <andypoo@gmail.com>
Date:   Sun, 13 Oct 2019 19:04:12 +0300
Message-ID: <CAFeYvHUoZdM5kY6LCfUiy6pVVf4VU_SWHtKeyevYenC3FZ7mng@mail.gmail.com>
Subject: Regression in 4.14.147, 4.19.76, 5.2.18 leading to kernel panic on
 btrfs root fs mount
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Was not sure the correct way to escalate this quickly enough.  I
unfortunately discovered this issue while upgrading a server (remotely) to
4.19.78 (longterm).

*Bug 205181* <https://bugzilla.kernel.org/show_bug.cgi?id=205181> - kernel
panic when accessing btrfs root device with f2fs in kernel
https://bugzilla.kernel.org/show_bug.cgi?id=205181

Andrew.
