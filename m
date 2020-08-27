Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2E12549C5
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 17:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbgH0Pou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 11:44:50 -0400
Received: from sonic301-31.consmr.mail.ne1.yahoo.com ([66.163.184.200]:40658
        "EHLO sonic301-31.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726266AbgH0Pot (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Aug 2020 11:44:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1598543089; bh=tbWkllzWIaGgcH8csIPYZ8o2extvmrV9CWjzVhQB8+U=; h=Date:From:Reply-To:Subject:References:From:Subject; b=T6dPmdxfAnEsSb1wrPWBgQEzNvsO1C1yi0ajs3mKtzDy38JupElXQVzwBdEosofMNeqpvqsTKXLPmKPW/4EL3s+OcO9q/LXrr31Iqs5CgzERmIn/46ZNUHGxfMb7Tn+4oYh8HVvrOaFYh+E95SJ30vLFR9Sn9+KZthWeFjieNl0Q7MXzRvPbdF2U0/rRoiTgjMyRs9FgENVpVU7114LSOTyCpyPBGuKYBgQLRMUEmgs+GQFGJWrtnIOrEq5D3ktS6ErLKUKYrqU+s9yrr0qZ8n4E5GvZtZtdSseOHpvv//sXzaT7UJzdsPqc0dkVp1Am8BzRtJOIn1w8az+kh7hvpg==
X-YMail-OSG: XliltwQVM1k3cUbuAArkF47yD3DFP1SVy_0ygVERp6eu8zRPZy2QK6xALB2lS7a
 .wIfTZyJVIXjG7PG3aj1R5Nnpcfv_PA5vMzpaMWdOfOOyey02BMSGC.wiw7vLmRJGDGzSxrp7wH9
 K6IPK4lv1Mmj7aqlhP1To5YScH83MUrNinOfkNChIbCUGTHk1prvP4mNUbkfkugF1GVlLGSZdms0
 WOl5k3W.HgOOiFZ1xA4yx3MQlfva5UZKeCokqtuhJlaR.m4ELgXQ2EentYPBRA7sta3C8NoBMYQD
 T6UZoQBIzyiWSjA7BEOfbXZMdCKq1EyY0Is1yVtwcG8HhHusSi2MNBcLUrMZL0EhthRP1pLBvI.s
 uywXpfDyyuvU0wCXOcFoUfMtQZMIRNSTuLb37A2usmu0J8vBzWkWGKmaVl1rFbGqtFlHKYpauKVf
 Mzjk885qdGhP99t2MtKscnR.4FGohTrNFF7wPUKi7Abggo9dMhCJJg8yraQdaftJnO9CFTLR1_EU
 qHBExeTHzlPz24dbqIUTsWMRb6BcuEJoQpVxfvzMYsWyOVKK0M4VXv8UzHeSZLYvT6SMMbXBJgTj
 3xhe2mpIrnOusloX0Uwy_C94ujJMF2PYWCJ_lYMFaAcyjentZLwHXRhIqNR0E5MXdTG5FcMB8xv.
 xf73MjVQEfJ1baEOOkFAM_iZTcduP.jBsXHDwwMvZ6e.oKINnYN6agWTWgyzE9Axv6j7J7uNptd2
 7K3y9XC41I6qMKtBjgkdJ0l7MgAZTH2.xhBTM6rOLocYVoANRrTJYan.ayKgJSIBMMjqu3tKE7SE
 AsBLdOr4WQMWjh2dSoeKGPg2hJe3I7KY_7KkwOhvuS1xT_VXa4yuM8jMIubpBlLy3zZIAldiJHM_
 cF_2HbtKoMSbVRYw47xkpFcRKYvY0SHfhNbqRKvR6TF_9jr713N5iZDclPBqHmWyi9G_AW226L_j
 4q66D0O__Ci1DdNiGnDzi8vfBX.23MIwCTq6AqYWzmdRG_fJfwuxhpL01UGAbP08V8JrNp3h.B1z
 IcHwDCimNICyyUhM_JnY.75k6FMFV2qZBTB_WiTbW4ignlfD299j4ErF.pPilSFJzsQ9YEwnIEKd
 qVzq37CcXx8ChNBROuJDdni9ClQDhG69PZoBk7Vj2yaPcFAGOh2Hri_jK2HRKd5EzLBeN9Nn8mHc
 m7bIfH3xGXBSGQ8Jx1Dpcgd8KgUGW274XBuZRkg2Wi2mBt8N7t9.zfoMJ1Se9oj3J6Fxohf1E3hu
 lBTPA._8.X5_1LMuApj.9WZhbmRwKqk.GZZAV5_k_b5x7tSYIdKzKVSNQbdQXL_LnbXMqhYDTZO5
 ChaDb.sHa58T3vdC5Rg0kIxQxuEQcIwGX8abJMYCFkdaOemKftCet9bjTKt4Hh8_HYIqwOLDCVLH
 ikG6oEjz3y8w4mN7geWMOcdSc240FkzHx5qESeqpnX.F9xMyuI48N
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.ne1.yahoo.com with HTTP; Thu, 27 Aug 2020 15:44:49 +0000
Date:   Thu, 27 Aug 2020 15:44:44 +0000 (UTC)
From:   Katie Higgins <khi584463@gmail.com>
Reply-To: khi584463@gmail.com
Message-ID: <1579032242.7322421.1598543084353@mail.yahoo.com>
Subject: Nice to meet you
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1579032242.7322421.1598543084353.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16489 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:79.0) Gecko/20100101 Firefox/79.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I am interested in you
