Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4976392D3
	for <lists+stable@lfdr.de>; Sat, 26 Nov 2022 01:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiKZAkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 19:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiKZAkO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 19:40:14 -0500
X-Greylist: delayed 407 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 25 Nov 2022 16:40:13 PST
Received: from mail.psssf.go.tz (mail.psssf.go.tz [196.11.255.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74C6528AC
        for <stable@vger.kernel.org>; Fri, 25 Nov 2022 16:40:13 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.psssf.go.tz (Postfix) with ESMTP id 4D6931004A47;
        Sat, 26 Nov 2022 03:31:42 +0300 (EAT)
Received: from mail.psssf.go.tz ([127.0.0.1])
        by localhost (mail.psssf.go.tz [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id gOzgaBn9XR_7; Sat, 26 Nov 2022 03:31:42 +0300 (EAT)
Received: from localhost (localhost [127.0.0.1])
        by mail.psssf.go.tz (Postfix) with ESMTP id E7EC21004917;
        Sat, 26 Nov 2022 03:31:41 +0300 (EAT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.psssf.go.tz E7EC21004917
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=psssf.go.tz;
        s=psssfdkim; t=1669422702;
        bh=GgFYceHPfP/4Ju84fndFJB/TSJ1oqCCcVK78ii2DXwQ=;
        h=MIME-Version:To:From:Date:Message-Id;
        b=PFrB7DjXj2S786kX4fkt9X5m+IRVeNS0rXYAcX3nSR80CPntL1+vYTXsuCwPZ3kxH
         N1QMju2lYpqWh9C3Wf3lxiGLNKxJOtRDqN7OvhNgntegzcXhIyQYR3pLk2iUAIsnq5
         LgaDRiN+mzVG2yOIeTCmLRGwaozYbaxk3/tQMj1iWPQq1FWXTicj1C3bu/l6sNxJ7H
         MwpZfKOEn/PUWehCuaiET8fEzlY/9xGgw9tSUTX3ANu/RQMsaLj+MqH8UrfTUJkYEB
         wGxnZK8jZBbzKXiD/IARgmSNpK/ymB5VZdy+6lSZDFim3jpmt3YQoBkES2gcXOlTv6
         OVuX4ewDS+utA==
X-Virus-Scanned: amavisd-new at mail.psssf.go.tz
Received: from mail.psssf.go.tz ([127.0.0.1])
        by localhost (mail.psssf.go.tz [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 9DiexZ61hQPs; Sat, 26 Nov 2022 03:31:41 +0300 (EAT)
Received: from EC2AMAZ-O7KPIJ2.ec2.internal (ec2-3-238-242-41.compute-1.amazonaws.com [3.238.242.41])
        by mail.psssf.go.tz (Postfix) with ESMTPSA id 39B501004A24;
        Sat, 26 Nov 2022 03:31:34 +0300 (EAT)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: 
To:     Recipients <lusajo.anderson@psssf.go.tz>
From:   "Rowell" <lusajo.anderson@psssf.go.tz>
Date:   Fri, 25 Nov 2022 19:33:09 -0500
Reply-To: rowellhm0192@gmail.com
Message-Id: <20221126003135.39B501004A24@mail.psssf.go.tz>
X-Spam-Status: Yes, score=5.8 required=5.0 tests=BAYES_99,BAYES_999,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FORGED_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 0.9996]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 0.9996]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [rowellhm0192[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 RCVD_IN_MSPIKE_H2 RBL: Average reputation (+2)
        *      [196.11.255.52 listed in wl.mailspike.net]
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hope you get my mail
