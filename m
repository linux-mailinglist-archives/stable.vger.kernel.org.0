Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E372417B090
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 22:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgCEVXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 16:23:45 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:53382 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726111AbgCEVXo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Mar 2020 16:23:44 -0500
Received: from mailhost.synopsys.com (sv2-mailhost1.synopsys.com [10.205.2.133])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 7620A43BE1;
        Thu,  5 Mar 2020 21:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1583443424; bh=/QqK71SMs1vqs9qUfnk8qpjPln6Hhcnj2HtUQngyBXI=;
        h=Date:From:Subject:To:Cc:From;
        b=K/jrAcNBhycQ5nazSXuGai34fXp2ZqxLmu7AP05fyfQ9ctHRKa68Ur36iEwLySB2E
         5I0o+/fukemOeKGM4BYnW/RKp+BFcZ5rODv+M0aLgGWQpW6BkrkZVvJeR0ziD1RdPK
         t09KYedcjphomeimbY1GzeaW1IYXk/59/X0miJGjrV78oN3HK1RVqbdY/1fl2ul7lX
         5nRU0lR+VxZtq61jVsmUZn/7Ohi8y0aAZzpEqoQzwQ5PdDzu9q//SRsLcNC5wkqnt1
         oriHp5aybvqeamTlPiPuKk3s1FqjTUsWjUJRsdTUI5LeayY3z7KGRN7bfztEMBOrL5
         r2GUfj4wylsyw==
Received: from te-lab16 (nanobot.internal.synopsys.com [10.10.186.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 07A65A0096;
        Thu,  5 Mar 2020 21:23:42 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Thu, 05 Mar 2020 13:23:42 -0800
Date:   Thu, 05 Mar 2020 13:23:42 -0800
Message-Id: <cover.1583443184.git.thinhn@synopsys.com>
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 0/6] usb: dwc3: gadget: Misc transfer cancellation fixes
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable <stable@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series contains miscellaneous fixes to dwc3's gadget. Most of them are
related to transfer cancellation handling.


Thinh Nguyen (6):
  usb: dwc3: gadget: Don't clear flags before transfer ended
  usb: dwc3: gadget: Properly handle ClearFeature(halt)
  usb: dwc3: gadget: Wrap around when skip TRBs
  usb: dwc3: gadget: Give back staled requests
  usb: dwc3: gadget: Remove unnecessary checks
  usb: dwc3: gadget: Refactor dwc3_gadget_ep_dequeue

 drivers/usb/dwc3/gadget.c | 85 +++++++++++++++++++++++++++++++----------------
 1 file changed, 57 insertions(+), 28 deletions(-)

-- 
2.11.0

