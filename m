Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01CDECDDC0
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 10:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfJGIwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 04:52:50 -0400
Received: from ns1.tgtizmir.com ([217.116.196.59]:51884 "EHLO ns1.tgtizmir.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727103AbfJGIwu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Oct 2019 04:52:50 -0400
X-Greylist: delayed 16010 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Oct 2019 04:52:49 EDT
Received: from 127.0.0.1 (localhost [127.0.0.1])
        by ns1.tgtizmir.com (Postfix) with SMTP id B399954D798;
        Mon,  7 Oct 2019 04:37:12 +0300 (+03)
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received-SPF: pass (ns1.tgtizmir.com: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=dave@dbsoundfactory.com; helo=127.0.0.1;
Received: from [177.234.65.227]
        by 127.0.0.1;
        Sun, 06 Oct 2019 18:36:09 -0700
Message-ID: <6$fo$b9e601l9@345wxbn>
From:   "Mr Barrister Hans Erich" <dave@dbsoundfactory.com>
Reply-To: "Mr Barrister Hans Erich" <dave@dbsoundfactory.com>
To:     sswadek@speedyservices.com
Subject: RE:PERSONAL LETTER FROM MRS RASHIA AMIRA
Date:   Sun, 06 Oct 19 18:36:09 GMT
X-Mailer: eGroups Message Poster
MIME-Version: 1.0
Content-Type: multipart/alternative;
        boundary=".F.ED2A68C5DB75."
X-Priority: 3
X-MSMail-Priority: Normal
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--.F.ED2A68C5DB75.
Content-Type: text/plain;
Content-Transfer-Encoding: quoted-printable

Greetings

My name is Barrister Hans Erich.

I have a client who is interested to invest in your country, she is a well=
 known politician in her country and deserve a lucrative investment partne=
rship with you outside her country without any delay   Please can you mana=
ge such investment please Kindly reply for further details.

Your full names --------


Your urgent response will be appreciated

Thank you and God bless you.

Barrister Hans Erich

Yours sincerely,
Barrister Hans Erich
CONTACT: hanserich9helmut@gmail.com

--.F.ED2A68C5DB75.--

