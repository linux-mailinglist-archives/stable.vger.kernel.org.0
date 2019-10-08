Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 649A5CFDA7
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 17:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfJHPaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 11:30:01 -0400
Received: from sonic306-2.consmr.mail.bf2.yahoo.com ([74.6.132.41]:39521 "EHLO
        sonic306-2.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726057AbfJHPaB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 11:30:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1570548600; bh=zPC9p8T5S06DA73PD5F75wViZ/EpBpeYylTS7OqjCU4=; h=Date:From:Reply-To:Subject:From:Subject; b=pQwqKXTZrPimXcG8gXMRuccws9CM0oburunB9+NXlhFwXMzFhFYWMOZTDhXDF4OvNt2fkULsAU9FfOUN8KJbo4cW4AWRehJ1cUyOj9WwM4LSHlWRO0aG3fVIe3kua+HAZl7HFMHVvJVrCDsyl+/nr/aosNd7UuM0ncLndfcURCVS6WdA/00FOPp5MIe8sGZmjq+gJFawtPv62Iu40SmlDw3Am7G2gSjSpn9sQHCZ1g2D3YQ9hwx71C1dZVz2AsxnQDv2LLhktcP8kbirXEtQrbV6Cn6PZ17xYBhBuW54PqVMSTlLMv993Y6wVJFDn673BUjGOa0fsBAhoS0jeQZJRA==
X-YMail-OSG: brynsd8VM1nVLQdNxWsCOLzq3ZWV0rxcSdH8HgysqcYBgEN6anLRT.n6JJmoMae
 uIYgHtWDQO4v7exCQgN_MowgXt7RvXHDgMlZBxTo7oQpwaCP.4pB7lWbqxVFwz4WYBrdxtkq6LXd
 K73kMqgVnlK6L6scVeNz5diAvGkz3O4J7f8q0c9RTt.XB2wkDkVaCoM6jfoZZAj9FACcB6hd01P6
 udKPbspL7JO.7ngjBizBr0plR2ntdRrVX1eUtjx4wfa89tFbXdPkkzsE9fLWMl7XiM9a6Yc8YtPs
 5HkC.LGwITQF8tAXnxfJxpSJPvkeAm28XUIYS8DTJddFQn.Rzt5TXwzgdHwwBpW3sbVbnXjpsMxo
 qnkYlUMW8SAJ86SpE7VvHOKv_UkI3zOCjN0ybnqhov5PbVruedAi8kgIhsjeX8oc70PPL1VVcZFW
 INopNlZmww6X5bwTe1TWndZo94FomvgCE1Rrw5CjCiz6VmJrTmHdl7w_K59qMfm.TBZMT9zNDFvh
 Jz6VbR8n2fCdq5vZkxPDCFnxwdE6dsh6RWpiqvIHfPPHXJy0EEf0OkAw5UthQ8ai6.u3HlUnXwQ_
 W0pbKQmRvxMzv0Wr4JxYbwxs3HoEN36QiDHpVtZdzZihckid0upvX8Gnjz44n4k1QOWQ.ZXlcaPJ
 0cUZ1E.mNEOlMhbUUXJx9SAJ0nQTPBefAXOlBqQwuWr7Il3W2LPce426yVTmsa9g5HNnT8hszQOf
 pLRQ8sBwTtB2D5QuweNaSr80z_DOk9q4S8uJxgw8xSxnD3VssPgxQgxlKiT559ZWOeUg2.Ndq6Oe
 stZgXRkMgC_d5y.iN6.9cB9g8wvXFeeWMP7HY87AQ2sjzVGdUd0nXOSf_kRLfWiHYsG.4rBoPdBt
 UCm.vsms5g_0ARH7S0DxUq5y2xTrkwhWIPoPz7AbwUuaqQToepdFzikM3NYFKQGGDrLop.QFxFsV
 wkEG1qWSQQVM8MqnxgosnxwhJ2ifORKb3lH01KrNI.Q6I1c_p1m__DXS953Y_UyUqMvhs2hfTke_
 4jNcwsXWPuPOU6hrpeVqO6WkE4w0G4tiDkmBRekfkql5ksLBNRl90xA3vgLTdbokPCzjeAzr7V4H
 XxIs4UW.ndPQTE_XVgSL6mm9PCmzU.ea3_5JVq8AcZ5fVTn66mJbZtb0WJzvjrgfZO175EJfCmG8
 unMm5l92nHmUN0EdlUjOPvTt1HWVw2Cwx6EJH7XFz.y_.LCieIwvxFY65IKgx71g1sf4yDxQdEW6
 2gkEEO7T_.DLpIFQE7sOVFth4HM08uy.tRfynAdEWteSgrfPYb_ttxIhzcA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.bf2.yahoo.com with HTTP; Tue, 8 Oct 2019 15:30:00 +0000
Date:   Tue, 8 Oct 2019 15:29:55 +0000 (UTC)
From:   Ms Lisa Hugh <lisa.hugh222@gmail.com>
Reply-To: ms.lisahugh000@gmail.com
Message-ID: <337207775.3440413.1570548595180@mail.yahoo.com>
Subject: FROM MS LISA HUGH (BUSINESS).
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Dear Friend,

I am Ms Lisa Hugh work with the department of Audit and accounting manager here in the Bank(B.O.A).

Please i need your assistance for the transferring of thIs fund to your bank account for both of us benefit for life time investment, amount (US$4.5M DOLLARS).

I have every inquiry details to make the bank believe you and release the fund in within 5 banking working days with your full co-operation with me forsuccess.

Note/ 50% for you why 50% for me after success of the transfer to your bank
account.

Below information is what i need from you so will can be reaching each
other

1)Full name ...
2)Private telephone number...
3)Age...
4)Nationality...
5)Occupation ...


Thanks.

Ms Lisa Hugh
